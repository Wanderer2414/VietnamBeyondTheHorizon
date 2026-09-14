package com.wanderlab.vietnambeyondthehorizon.location_manager

import android.app.Activity
import android.content.Context
import android.location.LocationManager
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.common.api.ResolvableApiException
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

internal class LocationSettingsResolver(private val activity: AppCompatActivity) {


    public fun isGpsEnabled(): Boolean {
        val locationManager = activity.getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    suspend fun resolve(
        exception: ResolvableApiException
    ): Boolean {
        val request = IntentSenderRequest.Builder(exception.resolution.intentSender).build()

        return suspendCancellableCoroutine{cont ->
            activity.registerForActivityResult(
                ActivityResultContracts.StartIntentSenderForResult()
            ) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    cont.resume(true)
                } else {
                    cont.resume(false)
                }
            }.launch(request)
        }

    }
}
