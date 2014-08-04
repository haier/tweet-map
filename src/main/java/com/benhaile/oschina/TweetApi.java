package com.benhaile.oschina;

import com.benhaile.common.AppConfigTool;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

import java.io.IOException;

/**
 * Created by oschina on 2014/8/3.
 */
public class TweetApi {
    private static String type="json";

    /**
     * 根据code获取oschina的 token
     *
     * @param access_token
     */
    public static String postPub(String access_token ,String msg) {
        HttpClient client = new HttpClient();
        //User-Agent
        client.getParams().setParameter(HttpMethodParams.USER_AGENT,
                "Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.1.2) Gecko/20090803");

        AppConfigTool configTool = new AppConfigTool();
        PostMethod method = new PostMethod(configTool.getConfig("osc_host")+ configTool.getConfig("tweet_pub"));
        method.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET,"utf-8");

        NameValuePair access_token_ = new NameValuePair("access_token",access_token);
        NameValuePair msg_ = new NameValuePair("msg",msg);

        method.setRequestBody(new NameValuePair[] { access_token_,msg_});

        String responsestr = "";
        try {
            client.executeMethod(method);
            responsestr = new String(method.getResponseBodyAsString());
        } catch (HttpException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }finally {
            method.releaseConnection();
        }

        return responsestr;
    }
}
