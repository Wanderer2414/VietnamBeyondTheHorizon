package com.wanderlab.vietnambeyondthehorizon.log_fragments

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import com.wanderlab.vietnambeyondthehorizon.R
import androidx.fragment.app.Fragment

class LoginFragment: Fragment(R.layout.login_fragment) {
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        view.setOnClickListener {
            val imm = requireActivity().getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.hideSoftInputFromWindow(view.windowToken, 0)
            imm.hideSoftInputFromWindow(view.windowToken, 0)
        }
    }
}