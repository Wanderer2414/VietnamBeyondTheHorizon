package com.wanderlab.vietnambeyondthehorizon.page_router

import android.animation.ValueAnimator
import android.content.res.ColorStateList
import android.graphics.Color
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import androidx.core.app.ActivityCompat
import androidx.core.view.children
import androidx.fragment.app.Fragment
import androidx.transition.TransitionManager
import com.wanderlab.vietnambeyondthehorizon.HomeFragment
import com.wanderlab.vietnambeyondthehorizon.MapFragment
import com.wanderlab.vietnambeyondthehorizon.R

class PageRouter(private val activity: AppCompatActivity, private val containerId: Int) {
    private val index = mapOf(
        HomeFragment::class to R.id.navigation_home_button,
        MapFragment::class to R.id.navigation_map_button
    )
    private var currentIndex = index.values.first()
    private val constraintLayout = activity.findViewById<ConstraintLayout>(R.id.home_navigation_box)

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

        val constraintSet = ConstraintSet().apply { clone(constraintLayout) }
        TransitionManager.beginDelayedTransition(constraintLayout)
        constraintSet.connect(
            R.id.slide_button,
            ConstraintSet.START,
            next,
            ConstraintSet.START
        )

        constraintSet.connect(
            R.id.slide_button,
            ConstraintSet.END,
            next,
            ConstraintSet.END
        )
        constraintSet.applyTo(constraintLayout)

        ValueAnimator.ofArgb(
            Color.WHITE,
            activity.getColor(R.color.background_forth)
        ).apply {
            duration = 300
            val imageView = activity.findViewById<FrameLayout>(currentIndex).children.first() as ImageView
            addUpdateListener {
                imageView.imageTintList = ColorStateList.valueOf(it.animatedValue as Int)
            }
            start()
        }

        ValueAnimator.ofArgb(
            activity.getColor(R.color.background_forth),
            Color.WHITE
        ).apply {
            duration = 300
            val imageView = activity.findViewById<FrameLayout>(next).children.first() as ImageView
            addUpdateListener {
                imageView.imageTintList = ColorStateList.valueOf(it.animatedValue as Int)
            }
            start()
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