package me.yohom.amapbasenavi.map

import android.graphics.BitmapFactory
import com.amap.api.maps.model.BitmapDescriptor
import com.amap.api.maps.model.BitmapDescriptorFactory
import me.yohom.amapbasenavi.AMapBaseNaviPlugin

object UnifiedAssets {
    private val assetManager = AMapBaseNaviPlugin.registrar.context().assets

    /**
     * 获取宿主app的图片
     */
    fun getBitmapDescriptor(asset: String): BitmapDescriptor {
        val assetFileDescriptor = assetManager.openFd(AMapBaseNaviPlugin.registrar.lookupKeyForAsset(asset))
        return BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(assetFileDescriptor.createInputStream()))
    }

    /**
     * 获取plugin自带的图片
     */
    fun getDefaultBitmapDescriptor(asset: String): BitmapDescriptor {
        return BitmapDescriptorFactory.fromAsset(AMapBaseNaviPlugin.registrar.lookupKeyForAsset(asset, "amap_base_navi"))
    }
}