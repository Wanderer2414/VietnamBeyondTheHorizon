package com.wanderlab.vietnambeyondthehorizon.location_manager

import android.animation.ValueAnimator
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView

fun MapView.animateTo(
    target: GeoPoint,
    duration: Long = 1000L
) {
    val start = mapCenter as GeoPoint
    val zoom = zoomLevelDouble
    controller.stopAnimation(true)
    ValueAnimator.ofFloat(0f, 1f).apply {
        this.duration = duration

        addUpdateListener { animator ->
            val progress = animator.animatedValue as Float

            val lat = start.latitude +
                    (target.latitude - start.latitude) * progress

            val lon = start.longitude +
                    (target.longitude - start.longitude) * progress

            controller.setCenter(
                GeoPoint(lat, lon)
            )
            controller.stopAnimation(true)
            controller.zoomTo(zoom + (15 - zoom) * progress)
            controller.stopAnimation(true)
        }

        start()
    }
}
