package com.wanderlab.vietnambeyondthehorizon

import android.Manifest
import android.os.Bundle
import android.view.animation.AnimationUtils
import android.widget.EditText
import android.widget.ImageButton
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.lifecycle.lifecycleScope
import com.wanderlab.vietnambeyondthehorizon.`location-manager`.LocationManager
import com.wanderlab.vietnambeyondthehorizon.`osm-connection`.osm_connection
import kotlinx.coroutines.launch
import org.osmdroid.config.Configuration
import org.osmdroid.tileprovider.tilesource.TileSourceFactory
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.CustomZoomButtonsController
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker

class NormalMapActivity : AppCompatActivity() {
    private val locationPermissionLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestMultiplePermissions()
        ) { permissions ->
            val fineGranted =
                permissions[Manifest.permission.ACCESS_FINE_LOCATION] == true
            val coarseGranted =
                permissions[Manifest.permission.ACCESS_COARSE_LOCATION] == true
        }
    private fun requestLocationPermission() {
        locationPermissionLauncher.launch(
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        )
    }

    private lateinit var map: MapView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_normal_map)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.activity_normal_map)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        WindowInsetsControllerCompat(window, window.decorView).apply {
            hide(WindowInsetsCompat.Type.systemBars())
            systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }

        requestLocationPermission()

        Configuration.getInstance().userAgentValue = packageName
        map = findViewById<MapView>(R.id.map)
        map.setMultiTouchControls(true)
        map.zoomController.setVisibility(CustomZoomButtonsController.Visibility.NEVER)
        map.setTileSource(TileSourceFactory.DEFAULT_TILE_SOURCE)

        val marker = Marker(map)
        marker.position = GeoPoint(10.7769, 106.7009)
        marker.title = "Ho Chi Minh City"
        marker.snippet = "OpenStreetMap marker"
        marker.icon = AppCompatResources.getDrawable(this, R.drawable.ic_home_filled)
        map.controller.setZoom(15.0)
        map.controller.setCenter(marker.position)
        map.overlays.add(marker)

        findViewById<ImageButton>(R.id.search_button).setOnClickListener {
            val text = this.findViewById<EditText>(R.id.search_text).text.toString()
            (lifecycleScope.launch {
                osm_connection.searchOpenStreetMap(text).forEach {
                    println(it)
                }

            })
        }
        val location_manager = LocationManager(this, map)
        findViewById<ImageButton>(R.id.current_button).setOnClickListener {
            val animation = AnimationUtils.loadAnimation(this, R.anim.button_click)
            it.startAnimation(animation)
            lifecycleScope.launch {
                val location = location_manager.currentLocation;
                if (location != null) location_manager.goto(location)
            }
        }

        findViewById<ImageButton>(R.id.home_button).setOnClickListener {
            val animation = AnimationUtils.loadAnimation(this, R.anim.button_click)
            it.startAnimation(animation)
            lifecycleScope.launch {
                location_manager.goto(marker.position)
            }
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