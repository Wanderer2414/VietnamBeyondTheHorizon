package com.wanderlab.vietnambeyondthehorizon.location_manager

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.app.ActivityCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.Priority
import com.wanderlab.vietnambeyondthehorizon.R
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView
import android.location.Location
import android.location.LocationListener
import androidx.activity.result.IntentSenderRequest
import org.osmdroid.views.overlay.Marker

internal class LocationManager(private val activity: AppCompatActivity) {

    init {
        checkLocationSettings()
    }
    var map: MapView? = null
        set(value) {
            field = value;
            currentMarker = Marker(map).apply {
                if (currentLocation != null) position = currentLocation
                title = "Your location"
                icon = AppCompatResources.getDrawable(activity, R.drawable.ic_current)
            }
            field?.overlays?.add(currentMarker)
        };
    var currentLocation: GeoPoint? = null
        set(value) {
            field = value
            if (value != null) currentMarker?.position = value;
            else
                disableCallbacks.forEach { it.invoke() }
        };
    fun setOnDisableListener(block: () -> Unit) {disableCallbacks += block}
    fun setOnEnableListener(block: () -> Unit) {enableCallbacks += block}
    private var disableCallbacks = emptyList<() -> Unit>()
    private var enableCallbacks = emptyList<() -> Unit>()
    private var currentMarker: Marker? = null;
    private var locationManager: android.location.LocationManager? = activity.getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager?
    private fun getCurrentLocation() {
        if (ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissionLauncher.launch(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION))
            return;
        }
        if (locationManager?.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER) == true) {
            locationManager?.requestLocationUpdates(
                android.location.LocationManager.GPS_PROVIDER,
                1_000L,
                0f,
                LocationManagerListener(this)
            )
        }
    }
    private fun checkLocationSettings() {
        val settingsClient =LocationServices.getSettingsClient(activity)
        val locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000L)
            .setMinUpdateIntervalMillis(500L)
            .build()

        val settingsRequest = LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest)
            .setAlwaysShow(true)
            .build()

        settingsClient
            .checkLocationSettings(settingsRequest)
            .addOnSuccessListener {
                getCurrentLocation()
            }
            .addOnFailureListener { exception ->
                if (exception is ResolvableApiException)
                    locationSettingsLauncher.launch(IntentSenderRequest.Builder(exception.resolution).build())
            }
    }
    private val locationSettingsLauncher =
        activity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult()
        ) { result ->
            if (result.resultCode == Activity.RESULT_OK)
                getCurrentLocation()
        }
    private val requestPermissionLauncher = activity.registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ){
        permissions ->
        if ((permissions[Manifest.permission.ACCESS_COARSE_LOCATION] == true) && (permissions[Manifest.permission.ACCESS_FINE_LOCATION] == true)) {
            locationManager = activity.getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager?
            getCurrentLocation();
        }
    }

    fun goto(newLocation: GeoPoint) = map?.animateTo(newLocation, 500L)

    internal class LocationManagerListener(private val manager: LocationManager): LocationListener {
        override fun onLocationChanged(location: Location) {
            if (manager.currentLocation == null)
                manager.enableCallbacks.forEach { it.invoke() }
            manager.currentLocation = GeoPoint(location.latitude, location.longitude)
        }

        override fun onProviderDisabled(provider: String) {
            super.onProviderDisabled(provider)
            manager.currentLocation = null;
        }

        override fun onProviderEnabled(provider: String) {
            super.onProviderEnabled(provider)
            manager.enableCallbacks.forEach { it.invoke() }
            manager.getCurrentLocation()
        }
    }
}
