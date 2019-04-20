package me.yohom.amapbasesearch.common

import android.Manifest
import androidx.core.app.ActivityCompat
import me.yohom.amapbasesearch.AMapBaseSearchPlugin

fun Any.checkPermission() {
    ActivityCompat.requestPermissions(
            AMapBaseSearchPlugin.registrar.activity(),
            arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.READ_PHONE_STATE),
            321
    )
}