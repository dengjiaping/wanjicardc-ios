package com.payeco.client;

import java.net.URLEncoder;

import com.payeco.tools.Base64;
import com.payeco.tools.Log;
import com.payeco.tools.Tools;
import com.payeco.tools.Xml;
import com.payeco.tools.http.HttpClient;
import com.payeco.tools.rsa.Signatory;
/**
 * 【H5页面标准版】商户对接下单接口封装
 * 易联服务器交易接口调用API封装，分别对以下接口调用进行了封装；
 * 接口封装了参数的转码（中文base64转码）、签名和验证签名、通讯和通讯报文处理
 * 1、【H5页面标准版】的商户订单下单接口
 * 2、【H5页面标准版】的生成订单支付重定向地址
 */
public class TransactionClientH5 {
    /**
     * 【H5页面标准版】的商户订单下单接口，本接口比SDK的下单接口增加了【returnUrl】和【clientIp】参数
     * @param merchantId        商户代码
     * @param merchOrderId      商户订单号
     * @param amount            商户订单金额，单位为元，格式： nnnnnn.nn
     * @param orderDesc         商户订单描述    字符最大128，中文最多40个；参与签名：采用UTF-8编码
     * @param tradeTime         商户订单提交时间，格式：yyyyMMddHHmmss，超过订单超时时间未支付，订单作废；不提交该参数，采用系统的默认时间（从接收订单后超时时间为30分钟）
     * @param expTime           交易超时时间，格式：yyyyMMddHHmmss， 超过订单超时时间未支付，订单作废；不提交该参数，采用系统的默认时间（从接收订单后超时时间为30分钟）
     * @param notifyUrl         异步通知URL
     * @param returnUrl         同步通知URL
     * @param extData           商户保留信息； 通知结果时，原样返回给商户；字符最大128，中文最多40个；参与签名：采用UTF-8编码
     * @param miscData          订单扩展信息   根据不同的行业，传送的信息不一样；参与签名：采用UTF-8编码
     * @param notifyFlag        订单通知标志    0：成功才通知，1：全部通知（成功或失败）  不填默认为“1：全部通知”
     * @param clientIp          针对配置了防钓鱼的商户需要提交，商户服务器通过获取访问ip得到该参数
     * @param mercPriKey        商户签名的私钥
     * @param payecoPubKey      易联签名验证公钥
     * @param payecoUrl         易联服务器URL地址，只需要填写域名部分
     * @param retXml            通讯返回数据；当不是通讯错误时，该对象返回数据
     * @return  处理状态码： 0000 : 处理成功， 其他： 处理失败
     * @throws Exception        E101:通讯失败； E102：签名验证失败；  E103：签名失败；
     */
    public static String MerchantOrderH5(String merchantId, String merchOrderId,
            String amount, String orderDesc, String tradeTime, String expTime,
            String notifyUrl, String returnUrl, String extData,
            String miscData, String notifyFlag, String clientIp, String mercPriKey,
            String payecoPubKey, String payecoUrl, Xml retXml) throws Exception {
		//交易参数
		String tradeCode = "PayOrder";
		String version = ConstantsClient.COMM_INTF_VERSION;
		
		//进行数据签名  
		String signData = "Version="+version+"&MerchantId=" + merchantId + "&MerchOrderId=" + merchOrderId 
				+ "&Amount=" + amount + "&OrderDesc=" + orderDesc + "&TradeTime=" + tradeTime + "&ExpTime="
				+ expTime + "&NotifyUrl=" + notifyUrl + "&ReturnUrl=" + returnUrl + "&ExtData=" + extData
				+ "&MiscData=" + miscData + "&NotifyFlag=" + notifyFlag + "&ClientIp=" + clientIp;
		
		// 私钥签名
		Log.println("PrivateKey = " + mercPriKey);
		Log.println("SignData = " + signData);
		String sign = Signatory.sign(mercPriKey, signData, ConstantsClient.PAYECO_DATA_ENCODE);
		if(Tools.isStrEmpty(sign)){
			throw new Exception("E103");
		}
		Log.println("sign=" + sign);

		//提交参数包含中文的需要做base64转码
		String orderDesc64 = Base64.encodeBytes(orderDesc.getBytes(ConstantsClient.PAYECO_DATA_ENCODE));
		String extData64 = Base64.encodeBytes(extData.getBytes(ConstantsClient.PAYECO_DATA_ENCODE));
		String miscData64 = Base64.encodeBytes(miscData.getBytes(ConstantsClient.PAYECO_DATA_ENCODE));
		//通知地址做URLEncoder处理
		String notifyUrlEn = URLEncoder.encode(notifyUrl, ConstantsClient.PAYECO_DATA_ENCODE);
		String returnUrlEn = URLEncoder.encode(returnUrl, ConstantsClient.PAYECO_DATA_ENCODE);
		
		String data64 = "Version="+version+"&MerchantId=" + merchantId + "&MerchOrderId=" + merchOrderId 
                    + "&Amount=" + amount + "&OrderDesc=" + orderDesc64 + "&TradeTime=" + tradeTime + "&ExpTime="
                    + expTime + "&NotifyUrl=" + notifyUrlEn + "&ReturnUrl=" + returnUrlEn + "&ExtData=" + extData64
                    + "&MiscData=" + miscData64 + "&NotifyFlag=" + notifyFlag + "&ClientIp=" + clientIp;

		//通讯报文
		String url= payecoUrl + "/ppi/merchant/itf.do"; //下订单URL
		data64 = "TradeCode=" + tradeCode + "&" + data64 + "&Sign=" + sign;
		HttpClient httpClient = new HttpClient();
		Log.println("url = " + url + "?" + data64);
		String retStr = httpClient.send(url, data64, ConstantsClient.PAYECO_DATA_ENCODE, ConstantsClient.PAYECO_DATA_ENCODE,
				ConstantsClient.CONNECT_TIME_OUT, ConstantsClient.RESPONSE_TIME_OUT);
		Log.println("retStr="+retStr);
		if(Tools.isStrEmpty(retStr)){
			throw new Exception("E101");
		}

		//返回数据的返回码判断
		retXml.setXmlData(retStr);
		String retCode = Tools.getXMLValue(retStr, "retCode");
		retXml.setRetCode(retCode);
		retXml.setRetMsg(Tools.getXMLValue(retStr, "retMsg"));
		if(!"0000".equals(retCode)){
			return retCode;
		}
		//获取返回数据
		String retVer = Tools.getXMLValue(retStr, "Version");
		String retMerchantId = Tools.getXMLValue(retStr, "MerchantId");
		String retMerchOrderId = Tools.getXMLValue(retStr, "MerchOrderId");
		String retAmount = Tools.getXMLValue(retStr, "Amount");
		String retTradeTime = Tools.getXMLValue(retStr, "TradeTime");
		String retOrderId = Tools.getXMLValue(retStr, "OrderId");
		String retVerifyTime = Tools.getXMLValue(retStr, "VerifyTime");
		String retSign = Tools.getXMLValue(retStr, "Sign");
		
		//设置返回数据
		retXml.setTradeCode(tradeCode);
		retXml.setVersion(retVer);
		retXml.setMerchantId(retMerchantId);
		retXml.setMerchOrderId(retMerchOrderId);
		retXml.setAmount(retAmount);
		retXml.setTradeTime(tradeTime);
		retXml.setOrderId(retOrderId);
		retXml.setVerifyTime(retVerifyTime);
		retXml.setSign(retSign);
		
		//验证签名的字符串
		String backSign = "Version="+retVer+"&MerchantId=" + retMerchantId + "&MerchOrderId=" + retMerchOrderId 
				+ "&Amount=" + retAmount + "&TradeTime=" + retTradeTime + "&OrderId=" + retOrderId + "&VerifyTime=" + retVerifyTime;
		//验证签名
		retSign = retSign.replaceAll(" ", "+");
		boolean b = Signatory.verify(payecoPubKey, backSign, retSign, ConstantsClient.PAYECO_DATA_ENCODE);
		Log.println("PublicKey=" + payecoPubKey);
		Log.println("data=" + backSign);
		Log.println("Sign=" + retSign);
		Log.println("验证结果=" + b);
		if(!b){
			throw new Exception("E102");
		}
		return retCode;
	}
	
	
    /**
     * 【H5页面标准版】的生成订单支付重定向地址
	 * @param payecoUrl		：	易联服务器URL地址，只需要填写域名部分 
     * @param retXml 下单成功后的通讯返回数据
     * @return
     */
    public static String getPayInitRedirectUrl(String payecoUrl, Xml retXml) {
        String tradeId = "h5Init";
        String version = ConstantsClient.COMM_INTF_VERSION;
        String merchantId = retXml.getMerchantId();         //商户代码
        String merchOrderId = retXml.getMerchOrderId();     //商户订单号
        String amount = retXml.getAmount();                 //商户订单金额，单位为元，格式： nnnnnn.nn
        String tradeTime = retXml.getTradeTime();           //商户订单提交时间
        String orderId = retXml.getOrderId();               //易联订单号
        String verifyTime = retXml.getVerifyTime();         //验证时间戳
        String sign = retXml.getSign();                     //签名,下单时返回的签名
        
        String datas = "Version=" + version + "&MerchantId=" + merchantId
                + "&MerchOrderId=" + merchOrderId + "&Amount=" + amount
                + "&TradeTime=" + tradeTime + "&OrderId=" + orderId
                + "&VerifyTime=" + verifyTime + "&Sign=" + sign;
       
        String redirectUrl = payecoUrl + "/ppi/h5/plugin/itf.do?tradeId=" + tradeId + "&" + datas;
        
        Log.println("redirectUrl=" + redirectUrl);
        
        return redirectUrl;
    }	
}
