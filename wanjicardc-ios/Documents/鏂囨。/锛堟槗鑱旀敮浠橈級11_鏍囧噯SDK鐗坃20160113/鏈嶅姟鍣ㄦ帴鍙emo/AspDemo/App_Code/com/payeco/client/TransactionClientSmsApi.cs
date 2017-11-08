using System;
using System.IO;
using com.payeco;
using System.Web;


namespace com.payeco
{
    /**
      * 【短信+API接口版本】商户对接下单接口封装
      * 易联服务器交易接口调用API封装，分别对以下接口调用进行了封装；
      * 接口封装了参数的转码（中文base64转码）、签名和验证签名、通讯和通讯报文处理
      * 1、【短信+API接口版本】的短信验证发送接口
      * 2、【短信+API接口版本】的无磁无密交易接口
      */
    public class TransactionClientSmsApi
    {

	    /**
	     * 短信验证发送接口(【短信+API接口版本】)
	     * @param merchantId:		商户代码
	     * @param smId			：  短信凭证号
	     * @param merchOrderId	:	商户订单号
	     * @param tradeTime		:	商户订单提交时间
	     * @param mobileNo		：	手机号码
	     * @param verifyTradeCode：	验证短信的交易码
	     * @param smParam		:	短信参数
	     * @param priKey		:	商户签名的私钥
	     * @param pubKey        :   易联签名验证公钥
	     * @param payecoUrl		：	易联服务器URL地址，只需要填写域名部分
	     * @param retXml        :   通讯返回数据；当不是通讯错误时，该对象返回数据
	     * @return 				: 处理状态码： 0000 : 处理成功， 其他： 处理失败
	     * @throws Exception    :  E101:通讯失败； E102：签名验证失败；  E103：签名失败；
	     */
	    public static String OrderSendSmCode(String merchantId, String smId, String merchOrderId,
			    String tradeTime, String mobileNo, String verifyTradeCode, String smParam,
			    String priKey, String pubKey, String payecoUrl, Xml retXml)
		    {
		    //交易参数
		    String tradeCode = "SendSmCode";
		    String version = ConstantsClient.COMM_INTF_VERSION;

	        //进行数据签名
	        String signData = "Version="+version+"&MerchantId=" + merchantId + "&SmId=" + smId
	    		    + "&MerchOrderId=" + merchOrderId + "&TradeTime=" + tradeTime + "&MobileNo="
	    		    + mobileNo + "&VerifyTradeCode=" + verifyTradeCode + "&SmParam=" + smParam;

	        // 私钥签名
		    LogPrint.println("PrivateKey=" + priKey);
		    LogPrint.println("data=" + signData);
	        String sign = Signatory.sign(priKey, signData, ConstantsClient.PAYECO_DATA_ENCODE);
		    if(Tools.isStrEmpty(sign)){
			    throw new Exception("E103");
		    }
		    LogPrint.println("sign=" + sign);

		    //提交参数包含中文的需要做base64转码
            String smParam64 = Base64.encodeBytes(ConstantsClient.PAYECO_DATA_ENCODE.GetBytes(smParam));
	        String data64 = "Version="+version+"&MerchantId=" + merchantId + "&SmId=" + smId
	    		    + "&MerchOrderId=" + merchOrderId + "&TradeTime=" + tradeTime + "&MobileNo="
	    		    + mobileNo + "&VerifyTradeCode=" + verifyTradeCode + "&SmParam=" + smParam64;

		    //通讯报文
		    String url= payecoUrl + "/ppi/merchant/itf.do"; //请求URL
		    data64 = "TradeCode=" + tradeCode + "&" + data64 + "&Sign=" + sign;
		    HttpClient httpClient = new HttpClient();
		    LogPrint.println("url = " + url + "?" + data64);
            String retStr = httpClient.send(url, data64, ConstantsClient.RESPONSE_TIME_OUT);
		    LogPrint.println("retStr="+retStr);
		    if(Tools.isStrEmpty(retStr)){
			    throw new Exception("E101");
		    }

		    //返回数据的返回码判断
		    retXml.setXmlData(retStr);
		    String retCode = Tools.getXMLValue(retStr, "retCode");
		    retXml.setRetCode(retCode);
		    retXml.setRetMsg(Tools.getXMLValue(retStr, "retMsg"));
		    if (!"0000".Equals(retCode)){
			    return retCode;
		    }
		    //获取返回数据
		    String retVer = Tools.getXMLValue(retStr, "Version");
		    String retMerchantId = Tools.getXMLValue(retStr, "MerchantId");
		    String retSmId = Tools.getXMLValue(retStr, "SmId");
		    String retMerchOrderId = Tools.getXMLValue(retStr, "MerchOrderId");
		    String retTradeTime = Tools.getXMLValue(retStr, "TradeTime");
		    String retComplated = Tools.getXMLValue(retStr, "Complated");
		    String retRemain = Tools.getXMLValue(retStr, "Remain");
		    String retExpTime = Tools.getXMLValue(retStr, "ExpTime");
		    String retSign = Tools.getXMLValue(retStr, "Sign");  //该凭证号还可以再次发送的短信次数。无值为不限制
		    //设置返回数据
		    retXml.setTradeCode(tradeCode);
		    retXml.setVersion(retVer);
		    retXml.setMerchantId(retMerchantId);
		    retXml.setSmId(retSmId);
		    retXml.setMerchOrderId(retMerchOrderId);
		    retXml.setTradeTime(retTradeTime);
		    retXml.setComplated(retComplated);
		    retXml.setRemain(retRemain);
		    retXml.setExpTime(retExpTime);
		    retXml.setSign(retSign);

		    //验证签名的字符串
		    String backSign = "Version="+retVer+"&MerchantId=" + retMerchantId +"&SmId=" + retSmId
				    + "&MerchOrderId=" + retMerchOrderId + "&TradeTime="+retTradeTime
				    + "&Complated=" + retComplated + "&Remain=" + retRemain + "&ExpTime=" + retExpTime;

		    //验证签名
		    retSign = retSign.Replace(" ", "+");
		    bool b = Signatory.verify(pubKey, backSign, retSign, ConstantsClient.PAYECO_DATA_ENCODE);
		    LogPrint.println("PublicKey=" + pubKey);
		    LogPrint.println("data=" + backSign);
		    LogPrint.println("Sign=" + retSign);
		    LogPrint.println("验证结果=" + b);
		    if(!b){
			    throw new Exception("E102");
		    }
		    return retCode;
	    }


        /**
         * 无磁无密交易接口(【短信+API接口版本】)
         * @param merchantId        商户代码
         * @param industryId        商户行业编号; 未上送此字段时，系统将使用商户配置中对应的行业
         * @param merchOrderId      商户订单号
         * @param amount            商户订单金额，单位为元，格式： nnnnnn.nn
         * @param orderDesc         商户订单描述    字符最大128，中文最多40个；参与签名：采用UTF-8编码
         * @param tradeTime         商户订单提交时间，格式：yyyyMMddHHmmss，超过订单超时时间未支付，订单作废；不提交该参数，采用系统的默认时间（从接收订单后超时时间为30分钟）
         * @param expTime           交易超时时间，格式：yyyyMMddHHmmss， 超过订单超时时间未支付，订单作废；不提交该参数，采用系统的默认时间（从接收订单后超时时间为30分钟）
         * @param notifyUrl         异步通知URL
         * @param extData           商户保留信息； 通知结果时，原样返回给商户；字符最大128，中文最多40个；参与签名：采用UTF-8编码
         * @param miscData          订单扩展信息   根据不同的行业，传送的信息不一样；参与签名：采用UTF-8编码
         * @param notifyFlag        订单通知标志    0：成功才通知，1：全部通知（成功或失败）  不填默认为“1：全部通知”
         * @param smId        		短信凭证号
         * @param smCode        	短信验证码
         * @param mercPriKey        商户签名的私钥
         * @param payecoPubKey      易联签名验证公钥
         * @param payecoUrl         易联服务器URL地址，只需要填写域名部分
         * @param retXml            通讯返回数据；当不是通讯错误时，该对象返回数据
         * @return  处理状态码： 0000 : 处理成功， 其他： 处理失败
         * @throws Exception        E101:通讯失败； E102：签名验证失败；  E103：签名失败；
         */
        public static String MerchantOrderPayByAcc(String merchantId, String industryId,
    		    String merchOrderId, String amount, String orderDesc, String tradeTime,
    		    String expTime, String notifyUrl, String extData, String miscData,
    		    String notifyFlag, String smId, String smCode,
                String mercPriKey, String payecoPubKey, String payecoUrl, Xml retXml)
        {
		    //交易参数
		    String tradeCode = "PayByAcc";
		    String version = ConstantsClient.COMM_INTF_VERSION;

		    //进行数据签名
		    String signData = "Version="+version+"&MerchantId=" + merchantId + "&IndustryId=" + industryId
				    + "&MerchOrderId=" + merchOrderId + "&Amount=" + amount + "&OrderDesc=" + orderDesc
				    + "&TradeTime=" + tradeTime + "&ExpTime=" + expTime + "&NotifyUrl=" + notifyUrl
				    + "&ExtData=" + extData + "&MiscData=" + miscData + "&NotifyFlag=" + notifyFlag
				    + "&SmId=" + smId + "&SmCode=" + smCode;

		    // 私钥签名
            LogPrint.println("PrivateKey = " + mercPriKey);
            LogPrint.println("SignData = " + signData);
		    String sign = Signatory.sign(mercPriKey, signData, ConstantsClient.PAYECO_DATA_ENCODE);
		    if(Tools.isStrEmpty(sign)){
			    throw new Exception("E103");
		    }
            LogPrint.println("sign=" + sign);

		    //提交参数包含中文的需要做base64转码
            String orderDesc64 = Base64.encodeBytes(ConstantsClient.PAYECO_DATA_ENCODE.GetBytes(orderDesc));
            String extData64 = Base64.encodeBytes(ConstantsClient.PAYECO_DATA_ENCODE.GetBytes(extData));
            String miscData64 = Base64.encodeBytes(ConstantsClient.PAYECO_DATA_ENCODE.GetBytes(miscData));
		    //通知地址做URLEncoder处理
            String notifyUrlEn = HttpUtility.UrlEncode(notifyUrl, ConstantsClient.PAYECO_DATA_ENCODE);

		    String data64 = "Version="+version+"&MerchantId=" + merchantId + "&IndustryId=" + industryId
				        + "&MerchOrderId=" + merchOrderId + "&Amount=" + amount + "&OrderDesc=" + orderDesc64
				        + "&TradeTime=" + tradeTime + "&ExpTime=" + expTime + "&NotifyUrl=" + notifyUrlEn
				        + "&ExtData=" + extData64 + "&MiscData=" + miscData64 + "&NotifyFlag=" + notifyFlag
   				 	    + "&SmId=" + smId + "&SmCode=" + smCode;

		    //通讯报文
		    String url= payecoUrl + "/ppi/merchant/itf.do"; //请求URL
		    data64 = "TradeCode=" + tradeCode + "&" + data64 + "&Sign=" + sign;
		    HttpClient httpClient = new HttpClient();
            LogPrint.println("url = " + url + "?" + data64);
            String retStr = httpClient.send(url, data64, ConstantsClient.RESPONSE_TIME_OUT);
            LogPrint.println("retStr=" + retStr);
		    if(Tools.isStrEmpty(retStr)){
			    throw new Exception("E101");
		    }

		    //返回数据的返回码判断
		    retXml.setXmlData(retStr);
		    String retCode = Tools.getXMLValue(retStr, "retCode");
		    retXml.setRetCode(retCode);
		    retXml.setRetMsg(Tools.getXMLValue(retStr, "retMsg"));
            if (!"0000".Equals(retCode))
            {
			    return retCode;
		    }
		    //获取返回数据
		    String retVer = Tools.getXMLValue(retStr, "Version");
		    String retMerchantId = Tools.getXMLValue(retStr, "MerchantId");
		    String retMerchOrderId = Tools.getXMLValue(retStr, "MerchOrderId");
		    String retAmount = Tools.getXMLValue(retStr, "Amount");
		    String retExtData = Tools.getXMLValue(retStr, "ExtData");
		    if (retExtData != null){
                retExtData = retExtData.Replace(" ", "+");
                retExtData = Base64.DecodingString(retExtData, ConstantsClient.PAYECO_DATA_ENCODE);
		    }
		    String retOrderId = Tools.getXMLValue(retStr, "OrderId");
		    String retStatus = Tools.getXMLValue(retStr, "Status");
		    String retPayTime = Tools.getXMLValue(retStr, "PayTime");
		    String retSettleDate = Tools.getXMLValue(retStr, "SettleDate");
		    String retSign = Tools.getXMLValue(retStr, "Sign");
		    //设置返回数据
		    retXml.setTradeCode(tradeCode);
		    retXml.setVersion(retVer);
		    retXml.setMerchantId(retMerchantId);
		    retXml.setMerchOrderId(retMerchOrderId);
		    retXml.setAmount(retAmount);
		    retXml.setExtData(retExtData);
		    retXml.setOrderId(retOrderId);
		    retXml.setStatus(retStatus);
		    retXml.setPayTime(retPayTime);
		    retXml.setSettleDate(retSettleDate);
		    retXml.setSign(retSign);

		    //验证签名的字符串
		    String backSign = "Version="+retVer+"&MerchantId=" + retMerchantId + "&MerchOrderId=" + retMerchOrderId
		      + "&Amount=" + retAmount + "&ExtData=" + retExtData + "&OrderId=" + retOrderId
		      + "&Status=" + retStatus + "&PayTime=" + retPayTime + "&SettleDate=" + retSettleDate;

		    //验证签名
            retSign = retSign.Replace(" ", "+");
		    bool b = Signatory.verify(payecoPubKey, backSign, retSign, ConstantsClient.PAYECO_DATA_ENCODE);
            LogPrint.println("PublicKey=" + payecoPubKey);
            LogPrint.println("data=" + backSign);
            LogPrint.println("Sign=" + retSign);
            LogPrint.println("验证结果=" + b);
		    if(!b){
			    throw new Exception("E102");
		    }
		    return retCode;
	    }

    }

}




