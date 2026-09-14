package com.wanderlab.vietnambeyondthehorizon

import android.os.Bundle
import android.widget.ImageButton
import androidx.appcompat.widget.AppCompatButton
import androidx.fragment.app.Fragment

class HomeFragment: Fragment(R.layout.home_fragment) {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        requireActivity().findViewById<AppCompatButton>(R.id.navigation_map_button).setOnClickListener {
            (requireActivity() as MainActivity).pageRouter.transitionTo(MapFragment())
        }
    }

}