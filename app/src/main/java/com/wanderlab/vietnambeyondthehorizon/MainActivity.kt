package com.wanderlab.vietnambeyondthehorizon

import android.os.Bundle
import android.view.View
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.wanderlab.vietnambeyondthehorizon.fragments.HomeFragment
import com.wanderlab.vietnambeyondthehorizon.fragments.MapFragment
import com.wanderlab.vietnambeyondthehorizon.location_manager.LocationManager
import com.wanderlab.vietnambeyondthehorizon.page_router.PageRouter

class MainActivity : AppCompatActivity() {
    internal lateinit var pageRouter: PageRouter;
    internal lateinit var locationManager: LocationManager;

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
    
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction().replace(R.id.content_container,
                HomeFragment()
            ).commit()
        }

        locationManager  = LocationManager(this);
        pageRouter = PageRouter(this, R.id.content_container)

        WindowInsetsControllerCompat(window, window.decorView).apply {
            hide(WindowInsetsCompat.Type.systemBars())
            systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }
    }

}