package com.wanderlab.vietnambeyondthehorizon.page_router

import android.animation.ValueAnimator
import android.content.res.ColorStateList
import android.graphics.Color
import android.view.View
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import androidx.fragment.app.Fragment
import androidx.transition.TransitionManager
import com.wanderlab.vietnambeyondthehorizon.fragments.HomeFragment
import com.wanderlab.vietnambeyondthehorizon.fragments.MapFragment
import com.wanderlab.vietnambeyondthehorizon.R
import com.wanderlab.vietnambeyondthehorizon.fragments.DiscoverFragment
import com.wanderlab.vietnambeyondthehorizon.fragments.ListFragment
import com.wanderlab.vietnambeyondthehorizon.fragments.SettingFragment
import kotlin.reflect.full.createInstance
class PageRouter(private val activity: AppCompatActivity, private val containerId: Int) {
    private val index = mapOf(
        DiscoverFragment::class to listOf(0, R.id.navigation_discover_button, R.id.navigation_discover),
        ListFragment::class to listOf(1, R.id.navigation_list_button, R.id.navigation_list),
        HomeFragment::class to listOf(2, R.id.navigation_home_button, R.id.navigation_home),
        MapFragment::class to listOf(3, R.id.navigation_map_button, R.id.navigation_map),
        SettingFragment::class to listOf(4, R.id.navigation_setting_button, R.id.navigation_setting)

    )
    private var currentIndex = index.values.elementAt(2)
    private val constraintLayout = activity.findViewById<ConstraintLayout>(R.id.home_navigation_box)
    private val dp = activity.resources.displayMetrics.density.toInt()
    init {
        ConstraintSet().apply {
            clone(constraintLayout)
            index.values.forEachIndexed { index, it ->
                if (index != 2) {
                    setMargin(it[2], ConstraintSet.TOP, 12 * dp)
                    setMargin(it[2], ConstraintSet.BOTTOM, 12 * dp)
                }
            }
            setMargin(index.values.elementAt(2)[1], ConstraintSet.START, 20 * dp)
            setMargin(index.values.elementAt(2)[1], ConstraintSet.END, 20 * dp)
            applyTo(constraintLayout)
        }

        index.forEach { (klass, ints) ->
            constraintLayout.findViewById<View>(ints[1]).setOnClickListener {
                transitionTo(klass.createInstance())
            }
        }
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


        val currentWidget = constraintLayout.findViewById<View>(currentIndex[1])
        val nextWidget = constraintLayout.findViewById<View>(nextIndex[1])
        val currentView = constraintLayout.findViewById<ImageView>(currentIndex[2])
        val nextView = constraintLayout.findViewById<ImageView>(nextIndex[2])


        TransitionManager.beginDelayedTransition(constraintLayout)
        ConstraintSet().apply {
            clone(constraintLayout)
            connect(
                R.id.slide_button,
                ConstraintSet.START,
                nextIndex[1],
                ConstraintSet.START
            )
            connect(
                R.id.slide_button,
                ConstraintSet.END,
                nextIndex[1],
                ConstraintSet.END
            )


            setMargin(currentIndex[1], ConstraintSet.START, 0)
            setMargin(currentIndex[1], ConstraintSet.END, 0)
            setMargin(currentIndex[2], ConstraintSet.TOP, 12 * dp)
            setMargin(currentIndex[2], ConstraintSet.BOTTOM, 12 * dp)

            setMargin(nextIndex[1], ConstraintSet.START, 20 * dp)
            setMargin(nextIndex[1], ConstraintSet.END, 20 * dp)
            setMargin(nextIndex[2], ConstraintSet.TOP, 0)
            setMargin(nextIndex[2], ConstraintSet.BOTTOM, 0)


            applyTo(constraintLayout)
        }


        ValueAnimator.ofArgb(
            Color.WHITE,
            activity.getColor(R.color.background_forth)
        ).apply {
            duration = 300
            addUpdateListener {
                currentView.imageTintList = ColorStateList.valueOf(it.animatedValue as Int)
            }
            start()
        }

        ValueAnimator.ofArgb(
            activity.getColor(R.color.background_forth),
            Color.WHITE
        ).apply {
            duration = 300
            addUpdateListener {
                nextView.imageTintList = ColorStateList.valueOf(it.animatedValue as Int)
            }
            start()
        }
        currentIndex = nextIndex

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