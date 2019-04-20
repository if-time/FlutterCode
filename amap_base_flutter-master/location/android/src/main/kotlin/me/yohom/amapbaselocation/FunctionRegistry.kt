package me.yohom.amapbaselocation

import me.yohom.amapbaselocation.location.Init
import me.yohom.amapbaselocation.location.StartLocate
import me.yohom.amapbaselocation.location.StopLocate

/**
 * 地图功能集合
 */
val MAP_METHOD_HANDLER: Map<String, MapMethodHandler> = mapOf(
)

/**
 * 搜索功能集合
 */
val SEARCH_METHOD_HANDLER: Map<String, SearchMethodHandler> = mapOf(
)

/**
 * 导航功能集合
 */
val NAVI_METHOD_HANDLER: Map<String, NaviMethodHandler> = mapOf(
)

/**
 * 定位功能集合
 */
val LOCATION_METHOD_HANDLER: Map<String, LocationMethodHandler> = mapOf(
        "location#init" to Init,
        "location#startLocate" to StartLocate,
        "location#stopLocate" to StopLocate
)
