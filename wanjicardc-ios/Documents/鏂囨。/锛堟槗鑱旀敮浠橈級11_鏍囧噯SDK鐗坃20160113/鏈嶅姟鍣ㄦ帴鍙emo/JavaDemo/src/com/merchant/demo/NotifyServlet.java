package com.merchant.demo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.payeco.client.TransactionClient;
import com.payeco.tools.Log;

/**
 * 接收订单结果通知处理例子；本例子只举例了订单结果的参数获取；签名验证；订单状态的判断。 测试接口可以通过以下URL进行测试：
 * http://127.0.0.18080/Notify.do?Version=2.0.0&MerchantId=302020000058&MerchOrderId=1407893794150&Amount=1.00&ExtData=5rWL6K+V&OrderId=302014081300038222&Status=02&PayTime=20140814111645&SettleDate=20140909&Sign=iDQ6gBAebnh1kzSb4XN0PP3bTIXTkwG9iE8PDnNZBEiTWpBknH4XoBAotC5G/RF4E+HUa7f9esJWEI1mKw84EMDt+gBY2KABe7fejIdzqS8AH5niJEJkWAKwm4qYQTkT4Ate9lshcOZDfcyZ7eqblXXHUYOFBsYtslANOsb+/IA=
 */
public class NotifyServlet extends HttpServlet {

	private static final long serialVersionUID = 842960784184979704L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// 设置编码
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");

		// 结果通知参数，易联异步通知采用GET提交
		String version = request.getParameter("Version");
		String merchantId = request.getParameter("MerchantId");
		String merchOrderId = request.getParameter("MerchOrderId");
		String amount = request.getParameter("Amount");
		String extData = request.getParameter("ExtData");
		String orderId = request.getParameter("OrderId");
		String status = request.getParameter("Status");
		String payTime = request.getParameter("PayTime");
		String settleDate = request.getParameter("SettleDate");
		String sign = request.getParameter("Sign");

		// 需要对必要输入的参数进行检查，本处省略...

		// 订单结果逻辑处理
		String retMsgJson = "";
		try {
			Log.setLogFlag(true);
			Log.println("---交易： 订单结果异步通知-------------------------");
			//验证订单结果通知的签名
			boolean b = TransactionClient.bCheckNotifySign(version, merchantId, merchOrderId, 
					amount, extData, orderId, status, payTime, settleDate, sign, 
					Constants.PAYECO_RSA_PUBLIC_KEY);
			if (!b) {
				retMsgJson = "{\"RetCode\":\"E101\",\"RetMsg\":\"验证签名失败!\"}";
				Log.println("验证签名失败!");
			}else{
				// 签名验证成功后，需要对订单进行后续处理
				
				if ("02".equals(status)) { // 订单已支付;
				//if ("0000".equals(status)) { // 若是互联金融行业, 订单已支付的状态为【0000】
					// 1、检查Amount和商户系统的订单金额是否一致
					// 2、订单支付成功的业务逻辑处理请在本处增加（订单通知可能存在多次通知的情况，需要做多次通知的兼容处理）；
					// 3、返回响应内容
					retMsgJson = "{\"RetCode\":\"0000\",\"RetMsg\":\"订单已支付\"}";
					Log.println("订单已支付!");
				} else {
					// 1、订单支付失败的业务逻辑处理请在本处增加（订单通知可能存在多次通知的情况，需要做多次通知的兼容处理，避免成功后又修改为失败）；
					// 2、返回响应内容
					retMsgJson = "{\"RetCode\":\"E102\",\"RetMsg\":\"订单支付失败+"+status+"\"}";
					Log.println("订单支付失败!status="+status);
				}
			}
		} catch (Exception e) {
			retMsgJson = "{\"RetCode\":\"E103\",\"RetMsg\":\"处理通知结果异常\"}";
			System.out.println("处理通知结果异常!e="+e.getMessage());
		}
		Log.println("-----处理完成----");
		//返回数据
	    PrintWriter out = response.getWriter();
	    out.println(retMsgJson);
	    out.close(); // for HTTP1.1
	}

}
