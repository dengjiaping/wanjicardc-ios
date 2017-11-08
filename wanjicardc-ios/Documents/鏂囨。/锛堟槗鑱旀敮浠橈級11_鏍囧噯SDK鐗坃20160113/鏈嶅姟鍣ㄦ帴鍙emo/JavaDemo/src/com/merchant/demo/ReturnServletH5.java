/**
 * 版权 (c) 2014 易联支付有限公司
 * 保留所有权利。
 */

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
 * 描述：接收同步通知(H5)，完成签名验证； 业务逻辑需要商户自行补充
 *
 * @author gan.feng
 * 创建时间：2014-11-27
 */

public class ReturnServletH5 extends HttpServlet{
    private static final long serialVersionUID = 1244117181221195725L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            Log.println("---交易： 同步通知(H5版本)-------------------------");
            //验证订单结果通知的签名
            boolean b = TransactionClient.bCheckNotifySign(version, merchantId, merchOrderId, 
                    amount, extData, orderId, status, payTime, settleDate, sign, 
                    Constants.PAYECO_RSA_PUBLIC_KEY);
            if (!b) {
                retMsgJson = "{\"RetCode\":\"E101\",\"RetMsg\":\"验证签名失败!\"}";
                Log.println("验证签名失败!");
            }else{
                // 签名验证成功后，需要对订单进行后续处理
                if ("02".equals(status)) { // 订单已支付
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
            Log.println("处理通知(H5)结果异常!e="+e.getMessage());
        }
        Log.println("--同步通知(H5)完成----");
        //返回数据
        PrintWriter out = response.getWriter();
        out.println(retMsgJson);
        out.close(); // for HTTP1.1
    }
}
