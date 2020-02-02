package com.example.mapglass

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.MapFragment
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

import android.os.Bundle
import androidx.wear.widget.SwipeDismissFrameLayout
import android.support.wearable.activity.WearableActivity
import android.view.Gravity
import android.view.View
import android.view.WindowInsets
import android.widget.FrameLayout
import android.widget.Toast

import kotlinx.android.synthetic.main.activity_maps.*

class MapsActivity : WearableActivity(), OnMapReadyCallback {

    /**
     * Map is initialized when it's fully loaded and ready to be used.
     * See [onMapReady]
     */
    private lateinit var mMap: GoogleMap

    public override fun onCreate(savedState: Bundle?) {
        super.onCreate(savedState)

        // Enables always on.
        setAmbientEnabled()

        setContentView(R.layout.activity_maps)

        // Enables the Swipe-To-Dismiss Gesture via the root layout (SwipeDismissFrameLayout).
        // Swipe-To-Dismiss is a standard pattern in Wear for closing an app and needs to be
        // manually enabled for any Google Maps Activity. For more information, review our docs:
        // https://developer.android.com/training/wearables/ui/exit.html
        swipe_dismiss_root_container.addCallback(object : SwipeDismissFrameLayout.Callback() {
            override fun onDismissed(layout: SwipeDismissFrameLayout?) {
                // Hides view before exit to avoid stutter.
                layout?.visibility = View.GONE
                finish()
            }
        })

        // Adjusts margins to account for the system window insets when they become available.
        swipe_dismiss_root_container.setOnApplyWindowInsetsListener { _, insetsArg ->
            val insets = swipe_dismiss_root_container.onApplyWindowInsets(insetsArg)

            val params = map_container.layoutParams as FrameLayout.LayoutParams

            // Add Wearable insets to FrameLayout container holding map as margins
            params.setMargins(
                insets.systemWindowInsetLeft,
                insets.systemWindowInsetTop,
                insets.systemWindowInsetRight,
                insets.systemWindowInsetBottom
            )
            map_container.layoutParams = params

            insets
        }

        // Obtain the MapFragment and set the async listener to be notified when the map is ready.
        val mapFragment = map as MapFragment
        mapFragment.getMapAsync(this)
    }

    override fun onMapReady(googleMap: GoogleMap) {
        // Map is ready to be used.
        mMap = googleMap

        // Inform user how to close app (Swipe-To-Close).
        val duration = Toast.LENGTH_LONG
        val toast = Toast.makeText(getApplicationContext(), R.string.intro_text, duration)
        toast.setGravity(Gravity.CENTER, 0, 0)
        toast.show()

        // Adds a marker in NY, NY and moves the camera.
//        val rockafeller = LatLng(40.758740, -73.978674)
//        val place1 = LatLng(40.838026, -73.881681) // in bronx
//        val place2 = LatLng(40.669832, -73.939376)  // in brooklyn

//
//        mMap.addMarker(MarkerOptions().position(rockafeller).title("Rockafeller Center"))
//        mMap.addMarker(MarkerOptions().position(place1).title("bronx"))
//        mMap.addMarker(MarkerOptions().position(place2).title("brooklyn"))
//        mMap.moveCamera(CameraUpdateFactory.newLatLng(rockafeller))



        // in brooklyn
        val crime1 = LatLng(40.669832, -73.939376) // FELONY ASSAULT
        mMap.addMarker(MarkerOptions().position(crime1).title("FELONY ASSAULT").icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))))



//        mMap.addMarker(MarkerOptions().position(crime1).title("FELONY ASSAULT"))

        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(crime1, 10.toFloat()))


//        mMap.moveCamera(CameraUpdateFactory.newLatLng(rockafeller))

//      [LatLng(40.758740, -73.978674), "GRAND LARCENY"]
//
//        mMap.moveCamera(CameraUpdateFactory.newLatLng(place1))
//        mMap.moveCamera(CameraUpdateFactory.newLatLng(place2))

//        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(place1, 10.toFloat()))

//      mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(place1, 12.00))
//      mMap.addMarker(MarkerOptions().position(place1).title("GRAND LARCENY"))
//      mMap.setOnMapLongClickListener(this);

//      val place2 = LatLng(40.742699, 	-73.998655)
//      mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(place2, 13.toFloat()))
    }
}
