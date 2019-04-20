package me.yohom.amapbasenavi.common

import android.Manifest
import androidx.core.app.ActivityCompat
import me.yohom.amapbasenavi.AMapBaseNaviPlugin

fun Any.checkPermission() {
    ActivityCompat.requestPermissions(
            AMapBaseNaviPlugin.registrar.activity(),
            arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.READ_PHONE_STATE),
            321
    )
}