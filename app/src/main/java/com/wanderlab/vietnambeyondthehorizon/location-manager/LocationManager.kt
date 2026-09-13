package com.wanderlab.vietnambeyondthehorizon.`location-manager`

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.ComponentActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.app.ActivityCompat
import androidx.lifecycle.lifecycleScope
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.Priority
import com.wanderlab.vietnambeyondthehorizon.R
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker

internal class LocationManager(private val activity: ComponentActivity, private val map: MapView) {
    init {
        fetch()
    }
    private fun fetch() {
        activity.lifecycleScope.launch {
            currentLocation = getCurrentLocation();
            while (currentLocation != null) {
                currentLocation = getCurrentLocation()
                current_marker.position = currentLocation;
            }
        }
    }
    var currentLocation: GeoPoint? = null
        suspend fun get() {
            if (currentLocation == null) {
                currentLocation = getCurrentLocation();
                fetch()
            }
            currentLocation;
        };
    private var current_marker = Marker(map);
    private val settingsResolver = LocationSettingsResolver(activity)

    private val locationRequest =
        LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            10_000L
        ).build()

    private suspend fun getCurrentLocation(): GeoPoint? {
        if (
            ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return null
        }

        val fusedLocationClient =
            LocationServices.getFusedLocationProviderClient(activity)

        val settingsClient =
            LocationServices.getSettingsClient(activity)

        val settingsRequest =
            LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest)
                .setAlwaysShow(true)
                .build()

        try {
            settingsClient
                .checkLocationSettings(settingsRequest).await()

        } catch (e: ResolvableApiException) {
            val enabled = settingsResolver.resolve(e)
            if (!enabled) return null
        } catch (e: Exception) {
            return null
        }

        try {
            val location = fusedLocationClient.getCurrentLocation(
                Priority.PRIORITY_HIGH_ACCURACY,
                null
            ).await()
            val result = GeoPoint(location.latitude, location.longitude)

            if (current_marker != null) map.overlays.remove(current_marker)
            current_marker = Marker(map).apply {
                position = result
                title = "Your location"
                icon = AppCompatResources.getDrawable(activity, R.drawable.ic_current)
            }
            map.overlays.add(current_marker)
            return result;
        }
        catch (e: Exception){
            return null;
        }
    }
    fun goto(newLocation: GeoPoint) = map.animateTo(newLocation, 500L)

}
