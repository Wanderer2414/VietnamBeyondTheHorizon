package com.wanderlab.vietnambeyondthehorizon.page_router

import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import com.wanderlab.vietnambeyondthehorizon.HomeFragment
import com.wanderlab.vietnambeyondthehorizon.MapFragment
import com.wanderlab.vietnambeyondthehorizon.R

class PageRouter(private val activity: AppCompatActivity, private val containerId: Int) {
    private val index = mapOf(
        HomeFragment::class to 1,
        MapFragment::class to 2
    )
    private var currentIndex = 1;

    fun transitionTo(fragment: Fragment) {
        val next = index[fragment::class]
        if (next == null || next == currentIndex) return;
        var enterAnim = R.anim.slide_in_left
        var exitAnim = R.anim.slide_out_right
        var popEnterAnim = R.anim.slide_in_right
        var popExitAnim = R.anim.slide_out_left

        if (next > currentIndex) {
            enterAnim = R.anim.slide_in_right
            exitAnim = R.anim.slide_out_left

            popEnterAnim = R.anim.slide_in_left
            popExitAnim = R.anim.slide_out_right
        }

        currentIndex = next

        activity.supportFragmentManager
            .beginTransaction()
            .setCustomAnimations(
                enterAnim,
                exitAnim,
                popEnterAnim,
                popExitAnim
            )
            .replace(containerId, fragment)
            .addToBackStack(null)
            .commit()

    }
}