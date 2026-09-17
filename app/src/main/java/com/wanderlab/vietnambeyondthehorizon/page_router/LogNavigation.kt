package com.wanderlab.vietnambeyondthehorizon.page_router

import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.Fragment
import com.wanderlab.vietnambeyondthehorizon.home_fragments.HomeFragment
import com.wanderlab.vietnambeyondthehorizon.R
import com.wanderlab.vietnambeyondthehorizon.log_fragments.LoginFragment

class LogNavigation(private val activity: AppCompatActivity, private val containerId: Int) {
    private val index = mapOf(
        LoginFragment::class to listOf(0)
    )
    private var currentIndex = index.values.elementAt(0)
    private val constraintLayout = activity.findViewById<ConstraintLayout>(R.id.home_navigation_box)
    private val dp = activity.resources.displayMetrics.density.toInt()
    init {
        activity.supportFragmentManager.beginTransaction().replace(R.id.content_container,
            LoginFragment()
        ).commit()
    }
    private fun transitionTo(fragment: Fragment) {
        val nextIndex = index[fragment::class].apply {
            if (this == null || this === currentIndex) return;
        }!!

        var enterAnim = R.anim.slide_in_left
        var exitAnim = R.anim.slide_out_right
        var popEnterAnim = R.anim.slide_in_right
        var popExitAnim = R.anim.slide_out_left

        if (nextIndex[0] > currentIndex[0]) {
            enterAnim = R.anim.slide_in_right
            exitAnim = R.anim.slide_out_left

            popEnterAnim = R.anim.slide_in_left
            popExitAnim = R.anim.slide_out_right
        }

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