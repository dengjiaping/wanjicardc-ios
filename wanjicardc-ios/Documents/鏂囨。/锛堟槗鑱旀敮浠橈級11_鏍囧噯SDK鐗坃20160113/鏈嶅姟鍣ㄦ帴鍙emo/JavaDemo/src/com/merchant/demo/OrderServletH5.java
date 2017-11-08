package com.merchant.demo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.payeco.client.TransactionClientH5;
import com.payeco.tools.Log;
import com.payeco.tools.Tools;
import com.payeco.tools.Xml;

/**
 * 商户下单接口测试，接收客户端对接demo的下单请求，并返回下单结果数据给客户端对接demo
 * 手机访问本下单接口地址为： http://ip:端口/order.do
 * 如： http://127.0.0.1:8080/order.do
 */
public class OrderServletH5 extends HttpServlet {
	private static final long serialVersionUID = -5764372551610920519L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//设置编码
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		//设置订单数据；  商户在实际使用情况会有部分数据为手机端提交的数据
		String amount = request.getParameter("Amount");
		String orderDesc = request.getParameter("OrderDesc");
		String clientIp = request.getRemoteAddr();//商户用户访问IP地址
		String extData = "H5测试测试";
		//以下扩展参数是按互联网金融行业填写的；其他行业请参考接口文件说明进行填写
		String miscData = "13922897656|0||张三|440121197511140912|62220040001154868428||PAYECO201510285445||2|";  //互联网金融
		if(Tools.checkAmount(amount) == false){
			String retMsgJson = "{\"RetCode\":\"E105\",\"RetMsg\":\"金额格式错!\"}";
			//返回数据
		    PrintWriter out = response.getWriter();
		    out.println(retMsgJson);
		    out.close(); // for HTTP1.1
		    return;
		}

		//下订单处理自动设置的参数
		String merchOrderId = ""+System.currentTimeMillis();  //订单号；本例子按时间产生； 商户请按自己的规则产生
		String merchantId = Constants.MERCHANT_ID;
		String notifyUrl = Constants.MERCHANT_NOTIFY_URL;  //需要做URLEncode
		String returnUrl = Constants.MERCHANT_RETURN_URL;  //需要做URLEncode
		String tradeTime =  Tools.getSysTime();
		String expTime = ""; //采用系统默认的订单有效时间
		String notifyFlag = "0";

		String priKey = Constants.MERCHANT_RSA_PRIVATE_KEY;
		String pubKey = Constants.PAYECO_RSA_PUBLIC_KEY;
		String payecoUrl = Constants.PAYECO_URL;
		// 调用下单接口
		Xml retXml = new Xml();
		String retMsgJson = "for HTTP1.1";
		boolean bOK = true;

		try {
            Log.setLogFlag(true);
            Log.println("---交易： 商户下订单(H5版本)-------------------------");
            String ret = TransactionClientH5.MerchantOrderH5(merchantId, merchOrderId, amount, orderDesc, 
            		tradeTime, expTime, notifyUrl, returnUrl, extData, miscData, notifyFlag, clientIp, 
            		priKey, pubKey, payecoUrl, retXml);
            if (!"0000".equals(ret)) {
                bOK = false;
                retMsgJson = "{\"RetCode\":\"" + ret  + "\",\"RetMsg\":\"下订单接口返回错误!\"}";
            }
        } catch (Exception e) {
            bOK = false;
            String errCode = e.getMessage();
            if ("E101".equalsIgnoreCase(errCode)) {
                retMsgJson = "{\"RetCode\":\"E101\",\"RetMsg\":\"下订单接口无返回数据!\"}";
            } else if ("E102".equalsIgnoreCase(errCode)) {
                retMsgJson = "{\"RetCode\":\"E102\",\"RetMsg\":\"验证签名失败!\"}";
            } else if ("E103".equalsIgnoreCase(errCode)) {
                retMsgJson = "{\"RetCode\":\"E103\",\"RetMsg\":\"进行订单签名失败!\"}";
            } else {
                retMsgJson = "{\"RetCode\":\"E100\",\"RetMsg\":\"下订单通讯失败!\"}";
            }
        }
        //重定向到订单支付
        if(bOK){
        	//根据返回的参数组织向易联支付平台提交支付申请的URL
            String redirectUrl = TransactionClientH5.getPayInitRedirectUrl(payecoUrl, retXml);
            Log.println("PayURL : "+redirectUrl);
            
            //针对【支付申请URL】，可以采用直接sendRedirect转跳的方式；也可以采用页面确认后再转跳的方式；
            //商户根据自己的业务逻辑选择，建议在正式使用时采用sendRedirect转跳方式；
            //response.sendRedirect(redirectUrl); //sendRedirect转跳方式
            
            //--页面确认后再转跳的方式
            retMsgJson = "<html><head><title>易联支付H5测试-支付请求</title></head><body>支付请求URL: "+redirectUrl+"<br/>"
            			 +" <a href=\""+redirectUrl+"\">立即支付</a></body></html>";
            PrintWriter out = response.getWriter();
            out.println(retMsgJson);
            out.close(); // for HTTP1.1 
        }else{
            //返回数据
            PrintWriter out = response.getWriter();
            out.println(retMsgJson);
            out.close(); // for HTTP1.1 
        }
	}
}
