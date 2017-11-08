package com.merchant.demo;

import com.payeco.client.TransactionClientSmsApi;
import com.payeco.tools.Log;
import com.payeco.tools.Tools;
import com.payeco.tools.Xml;

/**
 * 【短信+API接口版本】的接口测试demo； 分别对以下接口进行测试
 * 1、【短信+API接口版本】的发送短信验证码接口（MerchantOrderSendSmCodeTest）
 * 2、【短信+API接口版本】的无磁无密交易接口（MerchantOrderPayByAccTest）
 */
public class DemoTestSmsApi {
	private static String  MerchOrderId_smId = "1434455324"; //短信凭证号，发送和验证时要保持一致
	
	/**
	 * 【短信+API接口版本】的发送短信验证码接口测试
	 */
	public static void MerchantOrderSendSmCodeTest() {
		// 设置参数
		String smId = MerchOrderId_smId;
		String mobileNo = "13922897656";
		String verifyTradeCode = "PayByAcc";
		String smParam = "|张三|440121197511140912|62220040001154868428|1.00";  //参数格式：行业编号|姓名|证件号码|银行卡号|交易金额
		String merchantId = Constants.MERCHANT_ID;
		String merchOrderId = ""; // 订单号
		String tradeTime = Tools.getSysTime();

		// 调用下单接口
		System.out.println("-------【短信+API接口版本】发送短信验证码接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClientSmsApi.OrderSendSmCode(merchantId, smId, merchOrderId, tradeTime, mobileNo, verifyTradeCode, smParam,
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("【短信+API接口版本】发送短信验证码接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("【短信+API接口版本】发送短信验证码接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("【短信+API接口版本】发送短信验证码接口测试----ok");
		System.out.println("------------------------------------------------");
	}

	/**
	 * 【短信+API接口版本】的无磁无密交易接口测试
	 */
	public static void MerchantOrderPayByAccTest(String smCodePay) {
		// 设置参数
		String amount = "1.00";
		String orderDesc = "通用商户充值";
		String extData = "充值测试"; //
		//以下扩展参数是按互联网金融行业填写的；其他行业请参考接口文件说明进行填写
		String miscData = "13922897656|0||张三|440121197511140912|62220040001154868428||PAYECO2015111945496||2|";  //互联网金融
		String merchOrderId = "" + System.currentTimeMillis(); // 订单号
		String merchantId = Constants.MERCHANT_ID;
		String notifyUrl = Constants.MERCHANT_NOTIFY_URL; // 封装的API会自动做URLEncode
		String tradeTime = Tools.getSysTime();
		String expTime = ""; // 采用系统默认的订单有效时间
		String notifyFlag = "0";
		String industryId = "";
		String smId = MerchOrderId_smId;
		String smCode = smCodePay;

		// 调用下单接口
		System.out.println("-------【短信+API接口版本】无磁无密交易接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClientSmsApi.MerchantOrderPayByAcc(merchantId, industryId, merchOrderId, amount, orderDesc, 
					tradeTime, expTime, notifyUrl, extData, miscData, notifyFlag, smId, smCode, 
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("【短信+API接口版本】无磁无密交易接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("【短信+API接口版本】无磁无密交易接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("【短信+API接口版本】无磁无密交易接口测试----ok");
		System.out.println("------------------------------------------------");
	}
	
	public static void main(String[] args) {
		//设置打印日志
		Log.setLogFlag(true);
		
		// 商户发送短信验证码接口测试
		MerchantOrderSendSmCodeTest();  //短信+API接口版本的发送短信验证码接口
		
		// 【短信+API接口版本】的无磁无密交易接口测试
		String smCode = "000000";		//测试环境的短信码为 ： 000000
		MerchantOrderPayByAccTest(smCode);
	}
}
