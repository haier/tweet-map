package com.benhaile.action;

import com.alibaba.fastjson.JSON;
import com.benhaile.beans.User;
import com.benhaile.common.JsonMsg;
import com.benhaile.oschina.UserApi;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/action/user")
public class UserAction extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user_id = request.getParameter("user_id");
		if(!StringUtils.isNumeric(user_id))
			return;

		String access_token =  Oauth2Action.Users().get(Long.valueOf(user_id));
	
		if(null == access_token){
			JsonMsg.json_out(JsonMsg.jsonError("请重新认证！",JsonMsg.ERROR_CODE_AUTH), response);
			return;
		}
		
		User user = UserApi.getUser(access_token);
		
		if(null == user || !StringUtils.isNumeric(user.getId())){
			JsonMsg.json_out(JsonMsg.jsonError("请重新认证！",JsonMsg.ERROR_CODE_AUTH), response);
			return;
		}
		
		JsonMsg.json_out(JSON.toJSONString(user), response);
	}
}
