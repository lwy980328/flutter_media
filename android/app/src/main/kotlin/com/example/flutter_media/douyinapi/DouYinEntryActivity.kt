package com.example.flutter_media.douyinapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import com.bytedance.sdk.open.aweme.CommonConstants
import com.bytedance.sdk.open.aweme.common.handler.IApiEventHandler
import com.bytedance.sdk.open.aweme.common.model.BaseReq
import com.bytedance.sdk.open.aweme.common.model.BaseResp
import com.bytedance.sdk.open.aweme.share.Share
import com.bytedance.sdk.open.douyin.DouYinOpenApiFactory
import com.bytedance.sdk.open.douyin.api.DouYinOpenApi

class DouYinEntryActivity : Activity(), IApiEventHandler {
    var douYinOpenApi: DouYinOpenApi? = null
    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        douYinOpenApi = DouYinOpenApiFactory.create(this)
        douYinOpenApi?.handleIntent(intent, this)
    }

    override fun onReq(req: BaseReq) {}
    override fun onResp(resp: BaseResp) {
//        if (resp.type == CommonConstants.ModeType.SHARE_CONTENT_TO_TT_RESP) {
//            val response = resp as Share.Response
//            // 抖音940以后，错误码除了response.errorCode字段，还增加了response.subErrorCode字段，帮助三方排查错误原因
//            Toast.makeText(this, "分享失败,errorCode: " + response.errorCode + "subcode" + response.subErrorCode + " Error Msg : " + response.errorMsg, Toast.LENGTH_SHORT).show()
//        }
        finish()
    }

    override fun onErrorIntent(intent: Intent?) {
        // 错误数据
//        Toast.makeText(this, "Intent出错", Toast.LENGTH_LONG).show()
        finish()
    }
}