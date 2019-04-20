package me.yohom.amapbase.location

import android.annotation.SuppressLint
import com.amap.api.location.AMapLocationClient
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import me.yohom.amapbase.AMapBasePlugin.Companion.registrar
import me.yohom.amapbase.LocationMethodHandler
import me.yohom.amapbase.common.log
import me.yohom.amapbase.common.parseFieldJson
import me.yohom.amapbase.common.toFieldJson
import me.yohom.amapbase.location.Init.locationClient

object Init : LocationMethodHandler {
    @SuppressLint("StaticFieldLeak")
    lateinit var locationClient: AMapLocationClient

    private var locationEventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        locationEventChannel = EventChannel(registrar.messenger(), "me.yohom/location_event")
        locationEventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                eventSink = sink
            }

            override fun onCancel(p0: Any?) {

            }
        })

        locationClient = AMapLocationClient(registrar.activity().applicationContext).apply {
            setLocationListener {
                eventSink?.success(UnifiedAMapLocation(it).toFieldJson())
            }
        }
        result.success("初始化成功")
    }
}

object StartLocate : LocationMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val optionJson = call.argument<String>("options") ?: "{}"

        log("startLocate android端: options.toJsonString() -> $optionJson")

        locationClient.setLocationOption(optionJson.parseFieldJson<UnifiedLocationClientOptions>().toLocationClientOptions())
        locationClient.startLocation()
        result.success("开始定位")
    }
}

object StopLocate : LocationMethodHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        locationClient.stopLocation()
        log("停止定位")
        result.success("停止定位")
    }
}