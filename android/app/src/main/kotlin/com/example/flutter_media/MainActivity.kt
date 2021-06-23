package com.example.flutter_media

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import com.bytedance.sdk.open.aweme.base.MediaContent
import com.bytedance.sdk.open.aweme.base.VideoObject
import com.bytedance.sdk.open.aweme.share.Share
import com.bytedance.sdk.open.douyin.DouYinOpenApiFactory
import com.bytedance.sdk.open.douyin.DouYinOpenConfig
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.ArrayList


object Constants{
    const val DOUYIN_CODE = "douyin"
    const val METHOD_CHANNEL_NAME = "flutter_plugin"
}

class MainActivity: FlutterActivity() {
    private var test = "native receive a message"


    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        setupMethodChannel()
    }



    private fun DouYinshare(uri: ArrayList<String>){
        var clientKey = "awxx5omz6apj2qyh"

        DouYinOpenApiFactory.init(DouYinOpenConfig(clientKey))

        val douYinOpenApi = DouYinOpenApiFactory.create(this)
        val request = Share.Request()
        val mUri = ArrayList<String>()
        for (item in uri){
            mUri.add(item)
        }

        val videoObject = VideoObject()
        videoObject.mVideoPaths = mUri
        val content = MediaContent()
        content.mMediaObject = videoObject
        request.mMediaContent = content

        douYinOpenApi.share(request)

//        if (request.equals(other = null)){
//            douYinOpenApi.share(request)
//        }else{
//            Log.i("android native", "request is null")
//        }
    }

    private fun setupMethodChannel() {
        MethodChannel(flutterEngine?.dartExecutor, Constants.METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            if (call.method == Constants.DOUYIN_CODE) {
                result.success(test)
                var urilist = call.argument<ArrayList<String>>("uri")
                Log.i("android native", urilist.toString())
                if (urilist != null) {
                    DouYinshare(urilist)
                }
            }
        }
    }
}
