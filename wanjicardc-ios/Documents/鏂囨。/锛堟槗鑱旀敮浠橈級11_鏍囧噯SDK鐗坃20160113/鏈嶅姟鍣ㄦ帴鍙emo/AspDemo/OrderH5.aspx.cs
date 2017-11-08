using System;
using com.payeco;
using com.merchant.demo;

/// <summary>
/// 说明： H5版本下订单服务器处理逻辑
/// </summary>
public partial class OrderH5 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
		//设置订单数据；  商户在实际使用情况会有部分数据为手机端提交的数据
        String amount = Request.Form["Amount"];
		String orderDesc = Request.Form["OrderDesc"];
        String clientIp = Request.UserHostAddress;  //商户用户访问IP地址
		String extData = "测试";
        //以下扩展参数是按互联网金融行业填写的；其他行业请参考接口文件说明进行填写
        String miscData = "13922897656|0||张三|440121197511140912|62220040001154868428||PAYECO201510285445||2|";  //互联网金融

        //检查提交参数的格式
		String retMsgJson = "";
		if(Tools.checkAmount(amount) == false){
			retMsgJson = "{\"RetCode\":\"E105\",\"RetMsg\":\"金额格式错!\"}";
			//返回数据
            Response.Write(retMsgJson);
            return;
		}

		//下订单处理自动设置的参数；商户请根据自己业务逻辑进行设置
		String merchOrderId = ""+Tools.currentTimeMillis();  //订单号；本例子按时间产生； 商户请按自己的规则产生
		String merchantId = Constants.MERCHANT_ID;
		String notifyUrl = Constants.MERCHANT_NOTIFY_URL;  //需要做URLEncode，API已经封装
        String returnUrl = Constants.MERCHANT_RETURN_URL;  //需要做URLEncode，API已经封装
		String tradeTime =  Tools.getSysTime();
		String expTime = ""; //采用系统默认的订单有效时间
		String notifyFlag = "0";

		// 调用下单接口
		com.payeco.Xml retXml = new com.payeco.Xml();
		bool bOK = true;
		try {
			LogPrint.setLogFlag(true);
            LogPrint.println("---交易： 下订单(H5版本)-------------------------");
			String ret = TransactionClientH5.MerchantOrderH5(merchantId,
					merchOrderId, amount, orderDesc, tradeTime, expTime,
                    notifyUrl, returnUrl, extData, miscData, notifyFlag, clientIp,
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".Equals(ret)){
				bOK=false;
				retMsgJson = "{\"RetCode\":\""+ret+"\",\"RetMsg\":\"下订单接口返回错误!\"}";
			}
		} catch (Exception ex) {
			bOK=false;
			String errCode  = ex.Message;
			if("E101".Equals(errCode)){
				retMsgJson = "{\"RetCode\":\"E101\",\"RetMsg\":\"下订单接口无返回数据!\"}";
			}else if("E102".Equals(errCode)){
				retMsgJson = "{\"RetCode\":\"E102\",\"RetMsg\":\"验证签名失败!\"}";
            }
            else if ("E103".Equals(errCode))
            {
                retMsgJson = "{\"RetCode\":\"E103\",\"RetMsg\":\"订单签名失败!\"}";
            }
            else
            {
				retMsgJson = "{\"RetCode\":\"E100\",\"RetMsg\":\"下订单通讯失败!\"}";
			}
		}

        //重定向到订单支付
        if(bOK){
        	//根据返回的参数组织向易联支付平台提交支付申请的URL
            String redirectUrl = TransactionClientH5.getPayInitRedirectUrl(Constants.PAYECO_URL, retXml);
            System.Console.WriteLine("PayURL : "+redirectUrl);

            //针对【支付申请URL】，可以采用直接sendRedirect转跳的方式；也可以采用页面确认后再转跳的方式；
            //商户根据自己的业务逻辑选择，建议在正式使用时采用sendRedirect转跳方式；
            //Response.Redirect(redirectUrl); //sendRedirect转跳方式

            //--页面确认后再转跳的方式
            retMsgJson = "<html><head><title>易联支付H5测试-支付请求</title></head><body>支付请求URL: "+redirectUrl+"<br/>"
            			 +" <a href=\""+redirectUrl+"\">立即支付</a></body></html>";
            Response.Write(retMsgJson);
		}else{
		    //返回数据
            Response.Write(retMsgJson);
        }
    }
}