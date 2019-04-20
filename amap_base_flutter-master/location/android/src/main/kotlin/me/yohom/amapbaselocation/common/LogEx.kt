package me.yohom.amapbaselocation.common

import android.util.Log
import me.yohom.amapbaselocation.BuildConfig

fun Any.log(content: String) {
    if (BuildConfig.DEBUG) {
        Log.d(this::class.simpleName, content)
    }
}