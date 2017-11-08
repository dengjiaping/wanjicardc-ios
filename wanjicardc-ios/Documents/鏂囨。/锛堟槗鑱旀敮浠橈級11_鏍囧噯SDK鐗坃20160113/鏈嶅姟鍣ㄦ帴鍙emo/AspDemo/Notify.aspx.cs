using System;
using com.payeco;
using com.merchant.demo;

/// <summary>
/// 说明： 订单结果通知逻辑处理
/// 也可通过以下URL进行模拟验证（针对测试环境的302020000058商户）
/// http://localhost:58311/AspDemo/Notify.aspx?Version=2.0.0&MerchantId=302020000058&MerchOrderId=1407893794150&Amount=1.00&ExtData=5rWL6K+V&OrderId=302014081300038222&Status=02&PayTime=20140814111645&SettleDate=20140909&Sign=iDQ6gBAebnh1kzSb4XN0PP3bTIXTkwG9iE8PDnNZBEiTWpBknH4XoBAotC5G/RF4E+HUa7f9esJWEI1mKw84EMDt+gBY2KABe7fejIdzqS8AH5niJEJkWAKwm4qYQTkT4Ate9lshcOZDfcyZ7eqblXXHUYOFBsYtslANOsb+/IA=
/// </summary>

public partial class Notify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
		// 结果通知参数，易联异步通知采用GET提交
        String version = Request.QueryString["Version"];
        if (Tools.isStrEmpty(version)) version = Request.Form["Version"];
        String merchantId = Request.QueryString["MerchantId"];
        if (Tools.isStrEmpty(merchantId)) merchantId = Request.Form["MerchantId"];
        String merchOrderId = Request.QueryString["MerchOrderId"];
        if (Tools.isStrEmpty(merchOrderId)) merchOrderId = Request.Form["MerchOrderId"];
        String amount = Request.QueryString["Amount"];
        if (Tools.isStrEmpty(amount)) amount = Request.Form["Amount"];
        String extData = Request.QueryString["ExtData"];
        if (Tools.isStrEmpty(extData)) extData = Request.Form["ExtData"];
        String orderId = Request.QueryString["OrderId"];
        if (Tools.isStrEmpty(orderId)) orderId = Request.Form["OrderId"];
        String status = Request.QueryString["Status"];
        if (Tools.isStrEmpty(status)) status = Request.Form["Status"];
        String payTime = Request.QueryString["PayTime"];
        if (Tools.isStrEmpty(payTime)) payTime = Request.Form["PayTime"];
        String settleDate = Request.QueryString["SettleDate"];
        if (Tools.isStrEmpty(settleDate))  settleDate = Request.Form["SettleDate"];
        String sign = Request.QueryString["Sign"];
        if (Tools.isStrEmpty(sign))     sign = Request.Form["Sign"];

		// 需要对必要输入的参数进行检查，本处省略...

		// 订单结果逻辑处理
		String retMsgJson = "";
		try {
			LogPrint.setLogFlag(true);
            LogPrint.println("---交易： 接收订单结果异步通知-------------------------");
			//验证订单结果通知的签名
			bool b = TransactionClient.bCheckNotifySign(version, merchantId, merchOrderId,
					amount, extData, orderId, status, payTime, settleDate, sign,
					Constants.PAYECO_RSA_PUBLIC_KEY);
			if (!b) {
				retMsgJson = "{\"RetCode\":\"E101\",\"RetMsg\":\"验证签名失败!\"}";
				LogPrint.println("验证签名失败!");
			}else{
				// 签名验证成功后，需要对订单进行后续处理
				if ("02".Equals(status)) { // 订单已支付
					// 1、检查Amount和商户系统的订单金额是否一致
					// 2、订单支付成功的业务逻辑处理请在本处增加（订单通知可能存在多次通知的情况，需要做多次通知的兼容处理）；
					// 3、返回响应内容
					retMsgJson = "{\"RetCode\":\"0000\",\"RetMsg\":\"订单已支付\"}";
					LogPrint.println("订单已支付!");
				} else {
					// 1、订单支付失败的业务逻辑处理请在本处增加（订单通知可能存在多次通知的情况，需要做多次通知的兼容处理，避免成功后又修改为失败）；
					// 2、返回响应内容
					retMsgJson = "{\"RetCode\":\"E102\",\"RetMsg\":\"订单支付失败+"+status+"\"}";
					LogPrint.println("订单支付失败!status="+status);
				}
			}
		} catch (Exception ex) {
			retMsgJson = "{\"RetCode\":\"E103\",\"RetMsg\":\"处理通知结果异常\"}";
			LogPrint.println("处理通知结果异常!e="+ex.Message);
		}
		LogPrint.println("-----处理完成----");

        //返回数据
        Response.Write(retMsgJson);
    }
}