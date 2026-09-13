package com.wanderlab.vietnambeyondthehorizon.`location-manager`

import android.app.Activity
import androidx.activity.ComponentActivity
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import com.google.android.gms.common.api.ResolvableApiException
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

internal class LocationSettingsResolver(
    activity: ComponentActivity
) {

    private var continuation: CancellableContinuation<Boolean>? = null

    private val launcher =
        activity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult()
        ) { result ->

            continuation?.let {
                if (it.isActive) {
                    it.resume(result.resultCode == Activity.RESULT_OK)
                }
            }

            continuation = null
        }

    suspend fun resolve(
        exception: ResolvableApiException
    ): Boolean = suspendCancellableCoroutine { cont ->

        continuation = cont

        val request = IntentSenderRequest.Builder(
            exception.resolution
        ).build()

        launcher.launch(request)

        cont.invokeOnCancellation {
            if (continuation === cont) {
                continuation = null
            }
        }
    }
}
