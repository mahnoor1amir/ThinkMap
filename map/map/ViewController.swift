//
//  ViewController.swift
//  map
//
//  Created by Bhargavi Sabbisetty on 2/1/20.
//  Copyright © 2020 Bhargavi Sabbisetty. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    var obj: [[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureAPI()
        // Do any additional setup after loading the view.
    }
    
    private func configureAPI()
    {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        performGoogleSearch(longitude: 42.3345358, latitude: -71.1005268, type: "police")
        
    }
    func performGoogleSearch(longitude: Double, latitude: Double, type: String) {
//        strings = nil
//        tableView.reloadData()

//        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")!
        let key = URLQueryItem(name: "key", value: "AIzaSyDb-Wz7X8BNVfh5qwvvqyszFfTskQ3f7cE") // use your key
        let location = URLQueryItem(name: "location", value: "42.3345358,-71.1005268")
        let radius = URLQueryItem(name: "radius", value: "10000")
        let type = URLQueryItem(name: "type", value: type)
        components.queryItems = [key, location,radius,type]

        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                print(String(describing: response))
                print(String(describing: error))
                return
            }

            guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                print("not JSON format expected")
                print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                return
            }

            guard let results = json["results"] as? [[String: Any]],
                let status = json["status"] as? String,
                status == "OK" else {
                    print("no results")
                    print(String(describing: json))
                    return
            }

            DispatchQueue.main.async {
                // now do something with the results, e.g. grab `formatted_address`:
                let strings = results.compactMap { $0["formatted_address"] as? String }
                let dict = ((results[0]["geometry"]! as! Dictionary<String, Any>)["location"]!) as? [String: Any]
                print(dict!["lat"])
                print(dict!["lng"])
            }
        }

        task.resume()
    }
//    private func fetchData(longitude: Double, latitude: Double, type: String){
//        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(longitude),\(latitude)&radius=5000&types=\(type)&key=AIzaSyDb-Wz7X8BNVfh5qwvvqyszFfTskQ3f7cE"
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//                            if error != nil {
//                                print(error!.localizedDescription)
//                            }
//                            guard let data = data else { return }
//            do {
//                if(type == "hospital"){
//                let hosps = try JSONDecoder().decode(temporary.self, from: data)
//                print(hosps.results!.count)
//                for hop in hosps.results!{
//                    print(hop.name)
//                }
//                }
//                else{
//                    let policestation = try JSONDecoder().decode(temporary.self, from: data)
//                    print(policestation.results!.count)
//                    for ps in policestation.results!{
//                        print(ps.place_id)
//                    }
//                }
//            }
//            catch let jsonError
//            {
//                print("error searializing json", jsonError)
//            }
//                            }.resume()
//    }
    
    
    override func viewDidAppear(_ animated: Bool) {


        let path = Bundle.main.path(forResource: "crime", ofType: "json")

                    print(path!)

                    let url = URL(fileURLWithPath: path!)
                    print(url)


            let data = try! Data(contentsOf: url)
            obj = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
        print(obj!.count)

    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        self.view.addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{(response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        if response == nil
        {
            print("ERROR")
        }
            else{
            
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
           let annotation = MKPointAnnotation()
            annotation.title = searchBar.text
//            self.addAnnotations(longitude: longitude!, latitude: latitude!, title: searchBar.text!)
//            print(self.mapView.annotations)
            annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
            self.mapView.addAnnotation(annotation)
            self.mapView.showsUserLocation = true
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)

            
            }
        
            }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
//        if(annotationView == nil){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        }
//        annotationView?.image = UIImage(named: "green")
//        print(annotationView?.annotation)
//        print(annotationView?.image)
//        print(annotationView)
//        print(annotationView?.annotation)
//        print(annotationView?.annotation?.coordinate)
        var coordinate = annotationView?.annotation?.coordinate
//        print(coordinate)
        var diff = coordinate!.latitude - coordinate!.longitude
        print(diff)
        var count = 0
        for crime in self.obj!{
            let longitude_diff = crime["Longitude"] as! Double - coordinate!.longitude
//            print(longitude_diff)
            let latitude_diff = crime["Latitude"] as! Double - coordinate!.latitude
//            print(latitude_diff)
            let distance = sqrt(abs(longitude_diff*longitude_diff) + abs(latitude_diff*latitude_diff))
            print(distance)
            if(distance < 0.09)
            {
                count = count + 1
            }
//            print(distance)
        }
        let tempo = Double((count*10)/self.obj!.capacity)
        print(tempo)
        if(tempo == 0)
        {
            annotationView?.image = UIImage(named: "red")
        }
        else if(tempo > 0 && tempo < 6){
            annotationView?.image = UIImage(named: "yellow")
        }
        else{
            annotationView?.image = UIImage(named: "green")
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("This annotation is selected \(view.annotation?.title ?? "dfsd")")
    }
}





