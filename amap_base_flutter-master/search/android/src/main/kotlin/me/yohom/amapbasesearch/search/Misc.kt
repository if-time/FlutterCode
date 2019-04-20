package me.yohom.amapbasesearch.search

import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.poisearch.*
import me.yohom.amapbasesearch.common.toFieldJson

fun LatLng.toLatLonPoint(): LatLonPoint {
    return LatLonPoint(latitude, longitude)
}

fun LatLonPoint.toLatLng(): LatLng {
    return LatLng(latitude, longitude)
}

fun PoiResult.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("\"pageCount\":\"$pageCount\",")
            .append("\"query\":\"$query\",")
            .append("\"bound\":\"$bound\",")
            .append("\"pois\":\"${pois.map { it.toFieldJson() }}\",")
            .append("\"searchSuggestionKeywords\":\"$searchSuggestionKeywords\",")
            .append("\"searchSuggestionCitys\":\"$searchSuggestionCitys\"")
            .append("}")
            .toString()
}

fun PoiItem.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("\"businessArea\":\"$businessArea\",")
            .append("\"adName\":\"$adName\",")
            .append("\"cityName\":\"$cityName\",")
            .append("\"provinceName\":\"$provinceName\",")
            .append("\"typeDes\":\"$typeDes\",")
            .append("\"tel\":\"$tel\",")
            .append("\"adCode\":\"$adCode\",")
            .append("\"poiId\":\"$poiId\",")
            .append("\"distance\":\"$distance\",")
            .append("\"title\":\"$title\",")
            .append("\"snippet\":\"$snippet\",")
            .append("\"latLonPoint\":${latLonPoint.toLatLng().toFieldJson()},")
            .append("\"cityCode\":\"$cityCode\",")
            .append("\"enter\":\"$enter\",")
            .append("\"exit\":\"$exit\",")
            .append("\"postcode\":\"$postcode\",")
            .append("\"email\":\"$email\",")
            .append("\"direction\":\"$direction\",")
            .append("\"isIndoorMap\":\"$isIndoorMap\",")
            .append("\"provinceCode\":\"$provinceCode\",")
            .append("\"parkingType\":\"$parkingType\",")
            .append("\"subPois\":${subPois.map { it.toFieldJson() }.toFieldJson()},")
            .append("\"indoorData\":\"${indoorData.toFieldJson()}\",")
            .append("\"photos\":${photos.map { it.toFieldJson() }.toFieldJson()},")
            .append("\"poiExtension\":${poiExtension.toFieldJson()},")
            .append("\"typeCode\":\"$typeCode\",")
            .append("\"shopID\":\"$shopID\"")
            .append("}")
            .toString()
}

fun PoiItemExtension.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("\"opentime\":\"$opentime\",")
            .append("\"rating\":\"${getmRating()}\"")
            .append("}")
            .toString()
}

fun Photo.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("title:$title,")
            .append("url:$url")
            .append("}")
            .toString()
}

fun SubPoiItem.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("\"poiId\":\"$poiId\",")
            .append("\"title\":\"$title\",")
            .append("\"subName\":\"$subName\",")
            .append("\"distance\":\"$distance\",")
            .append("\"latLonPoint\":\"${latLonPoint.toLatLng().toFieldJson()}\",")
            .append("\"snippet\":\"$snippet\",")
            .append("\"subTypeDes\":\"$subTypeDes\"")
            .append("}")
            .toString()
}

fun IndoorData.toFieldJson(): String {
    return StringBuilder()
            .append("{")
            .append("\"poiId\":\"$poiId\",")
            .append("\"floor\":\"$floor\",")
            .append("\"floorName\":\"$floorName\"")
            .append("}")
            .toString()
}