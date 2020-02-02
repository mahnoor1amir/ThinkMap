//
//  Hospital.swift
//  map
//
//  Created by Bhargavi Sabbisetty on 2/2/20.
//  Copyright © 2020 Bhargavi Sabbisetty. All rights reserved.
//

import Foundation
//
//  Hospital.swift
//  mapDemo
//
//  Created by Bhargavi Sabbisetty on 12/7/19.
//  Copyright © 2019 Bhargavi Sabbisetty. All rights reserved.
//

import Foundation

struct temporary: Decodable{
    
    let html_attributions:[String]?
    let next_page_token:String?
    let results:[location]?
    let status: String?
}

struct location: Decodable{
struct geometry: Decodable {
    struct location: Decodable {
        let lat: Double
        let lng: Double
    }
    struct viewport: Decodable {
        struct northeast: Decodable {
            let lat: Double
            let lng: Double
        }
        struct southwest: Decodable {
            let lat: Double
            let lng: Double
        }
    }
}
let icon: String?
let id: String
let name: String?
    struct opening_hours{
        let open: Bool?
    }
    let photos:[pic]?
let place_id: String?
struct plus_code: Decodable {
    let compond_code: String?
    let global_code: String?
}
    let rating: Float?
let reference: String?
let scope: String?
let types: [String]?
    let user_ratings_total: Int?
let vicinity: String?
}

struct pic: Decodable{
    let height: Int?
    let html_attributions: [String]?
    let photo_reference: String?
    let width:Int?
}
