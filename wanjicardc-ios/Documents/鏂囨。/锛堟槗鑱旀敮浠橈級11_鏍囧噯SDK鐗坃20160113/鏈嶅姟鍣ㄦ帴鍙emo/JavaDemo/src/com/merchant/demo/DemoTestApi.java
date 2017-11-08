package com.merchant.demo;

import com.payeco.client.TransactionClientApi;
import com.payeco.tools.Log;
import com.payeco.tools.Tools;
import com.payeco.tools.Xml;

/**
 * 【纯API接口版本】的接口测试demo； 分别对以下接口进行测试
 * 1、【纯API接口版本】的订单快捷支付接口（MerchantOrderPayQuickByAccTest）
 */
public class DemoTestApi {
	/**
	 * 【纯API接口版本】的订单快捷支付接口测试
	 */
	public static void MerchantOrderPayQuickByAccTest() {
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

		// 调用下单接口
		System.out.println("-------【纯API接口版本】的订单快捷支付接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClientApi.MerchantOrderPayQuickByAcc(merchantId, industryId, merchOrderId, amount, orderDesc, 
					tradeTime, expTime, notifyUrl, extData, miscData, notifyFlag, 
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("【纯API接口版本】的订单快捷支付接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("【纯API接口版本】的订单快捷支付接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("【纯API接口版本】的订单快捷支付接口测试----ok");
		System.out.println("------------------------------------------------");
	}
	
	public static void main(String[] args) {
		//设置打印日志
		Log.setLogFlag(true);
		
		// 【纯API接口版本】的订单快捷支付接口测试
		MerchantOrderPayQuickByAccTest();
	}
}
