using System;
using com.payeco;
using com.merchant.demo;

/// <summary>
/// 说明： SDK下订单服务器处理逻辑
/// </summary>
public partial class Order : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
		//设置订单数据；  商户在实际使用情况会有部分数据为手机端提交的数据
        String amount = Request.Form["Amount"];
		String orderDesc = Request.Form["OrderDesc"];
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
		String notifyUrl = Constants.MERCHANT_NOTIFY_URL;  //需要做URLEncode
		String tradeTime =  Tools.getSysTime();
		String expTime = ""; //采用系统默认的订单有效时间
		String notifyFlag = "0";

		// 调用下单接口
		com.payeco.Xml retXml = new com.payeco.Xml();
		bool bOK = true;
		try {
			LogPrint.setLogFlag(true);
            LogPrint.println("---交易： 下订单(SDK版本)-------------------------");
			String ret = TransactionClientSdk.MerchantOrder(merchantId,
					merchOrderId, amount, orderDesc, tradeTime, expTime,
					notifyUrl, extData, miscData, notifyFlag,
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

		//设置返回给手机Json数据
		if(bOK){
            retMsgJson = "{\"RetCode\":\"0000\",\"RetMsg\":\"下单成功\",\"Version\":\"" + retXml.getVersion()
                                    + "\",\"MerchOrderId\":\"" + retXml.getMerchOrderId()
                                    + "\",\"MerchantId\":\"" + retXml.getMerchantId()
                                    + "\",\"Amount\":\"" + retXml.getAmount()
                                    + "\",\"TradeTime\":\"" + retXml.getTradeTime()
                                    + "\",\"OrderId\":\"" + retXml.getOrderId()
                                    + "\",\"Sign\":\"" + retXml.getSign() + "\"}";
		}

		//返回数据
        Response.Write(retMsgJson);
    }
}