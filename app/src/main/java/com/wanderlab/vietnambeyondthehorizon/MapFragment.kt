package com.wanderlab.vietnambeyondthehorizon

import android.os.Bundle
import android.view.View
import android.view.animation.AnimationUtils
import android.widget.EditText
import android.widget.ImageButton
import androidx.appcompat.content.res.AppCompatResources
import androidx.appcompat.widget.AppCompatButton
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.wanderlab.vietnambeyondthehorizon.location_manager.LocationManager
import com.wanderlab.vietnambeyondthehorizon.osm_connection.osm_connection
import kotlinx.coroutines.launch
import org.osmdroid.config.Configuration
import org.osmdroid.tileprovider.tilesource.TileSourceFactory
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.CustomZoomButtonsController
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker

class MapFragment : Fragment(R.layout.map_fragment) {

    private lateinit var map: MapView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    private lateinit var locationManager: LocationManager
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        locationManager = (requireActivity() as MainActivity).locationManager
        locationManager.map = view.findViewById(R.id.map)

        Configuration.getInstance().userAgentValue = requireActivity().packageName
        map = view.findViewById(R.id.map)
        map.setMultiTouchControls(true)
        map.zoomController.setVisibility(CustomZoomButtonsController.Visibility.NEVER)
        map.setTileSource(TileSourceFactory.DEFAULT_TILE_SOURCE)

        val marker = Marker(map)
        marker.position = GeoPoint(10.7769, 106.7009)
        marker.title = "Ho Chi Minh City"
        marker.snippet = "OpenStreetMap marker"
        marker.icon = AppCompatResources.getDrawable(view.context, R.drawable.ic_home_filled)
        map.controller.setZoom(15.0)
        map.controller.setCenter(locationManager.currentLocation ?: marker.position)
        map.overlays.add(marker)

        view.findViewById<ImageButton>(R.id.search_button).setOnClickListener {
            val text = view.findViewById<EditText>(R.id.search_text).text.toString()
            (lifecycleScope.launch {
                osm_connection.searchOpenStreetMap(text).forEach {
                    println(it)
                }
            })
        }
        view.findViewById<ImageButton>(R.id.current_button).apply {
            isEnabled = (locationManager.currentLocation != null)
            setOnClickListener {
                val animation = AnimationUtils.loadAnimation(view.context, R.anim.button_click)
                it.startAnimation(animation)
                if (locationManager.currentLocation != null) locationManager.goto(locationManager.currentLocation!!)
            }
            locationManager.setOnEnableListener {
                isEnabled = true;
            }
        }

        view.findViewById<ImageButton>(R.id.home_button).setOnClickListener {
            val animation = AnimationUtils.loadAnimation(context, R.anim.button_click)
            it.startAnimation(animation)
            lifecycleScope.launch {
                locationManager.goto(marker.position)
            }
        }
        requireActivity().findViewById<AppCompatButton>(R.id.navigation_home_button).setOnClickListener {
            (requireActivity() as MainActivity).pageRouter.transitionTo(HomeFragment())
        }
    }

    override fun onResume() {
        super.onResume()
        map.onResume()
    }

    override fun onPause() {
        super.onPause()
        map.onPause()
    }
}