package me.yohom.amapbasesearch.common

import android.util.Log
import me.yohom.amapbasesearch.BuildConfig

fun Any.log(content: String) {
    if (BuildConfig.DEBUG) {
        Log.d(this::class.simpleName, content)
    }
}