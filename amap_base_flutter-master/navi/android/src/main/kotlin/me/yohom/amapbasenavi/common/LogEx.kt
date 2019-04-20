package me.yohom.amapbasenavi.common

import android.util.Log
import me.yohom.amapbasenavi.BuildConfig

fun Any.log(content: String) {
    if (BuildConfig.DEBUG) {
        Log.d(this::class.simpleName, content)
    }
}