package com.merchant.demo;

import com.payeco.client.TransactionClient;
import com.payeco.tools.Log;
import com.payeco.tools.Tools;
import com.payeco.tools.Xml;

/**
 * 各版本通用接口测试demo,分别对以下接口进行测试
 * 1、订单查询接口（OrderQueryTest）
 * 2、订单冲正接口（OrderReverseTest）
 * 3、订单退款申请接口（OrderRefundReqTest）
 * 4、订单退款查询接口（OrderRefundQueryTest）
 * 5、互联网金融行业银行卡解除绑定接口（UnboundBankCardTest）
 */
public class DemoTest {
	/**
	 * 订单查询接口测试
	 */
	public static void OrderQueryTest(String orderId) {
		// 设置参数
		String merchantId = Constants.MERCHANT_ID;
		String merchOrderId = orderId;  
		String tradeTime = Tools.getSysTime();

		// 调用查询接口
		System.out.println("-------订单查询接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClient.OrderQuery(merchantId, merchOrderId, tradeTime,
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("订单查询接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("订单查询接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("订单查询接口测试----ok");
		System.out.println("------------------------------------------------");
	}
	
	/**
	 * 订单冲正接口测试
	 */
	public static void OrderReverseTest(String orderId, String amt) {
		// 设置参数
		String amount = amt;
		String merchantId = Constants.MERCHANT_ID;
		String merchOrderId = orderId;  //需要填写已经存在的商户订单号
		String tradeTime = Tools.getSysTime();

		// 调用冲正接口
		System.out.println("-------订单冲正接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClient.OrderReverse(merchantId, merchOrderId, amount, tradeTime, 
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("订单冲正接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("订单冲正接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("订单冲正接口测试----ok");
		System.out.println("------------------------------------------------");
	}

	/**
	 * 订单退款申请接口测试
	 */
	public static void OrderRefundReqTest(String orderId, String amt) {
		// 设置参数
		String amount = amt;
		String merchantId = Constants.MERCHANT_ID;
		String merchOrderId = orderId;  //需要填写已经存在的商户订单号
		String merchRefundId = "" + System.currentTimeMillis(); // 退款申请号
		String tradeTime = Tools.getSysTime();

		// 调用冲正接口
		System.out.println("-------订单退款申请接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClient.OrderRefundReq(merchantId, merchOrderId, merchRefundId, amount, tradeTime, 
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("订单退款申请接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("订单退款申请接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("订单退款申请接口测试----ok");
		System.out.println("------------------------------------------------");
	}	

	/**
	 * 订单退款结果查询接口测试
	 */
	public static void OrderRefundQueryTest(String orderId, String refundId) {
		// 设置参数
		String merchantId = Constants.MERCHANT_ID;
		String merchOrderId = orderId;  //需要填写已经存在的商户订单号
		String merchRefundId = refundId; // 退款申请号
		String tradeTime = Tools.getSysTime();

		// 调用冲正接口
		System.out.println("-------订单退款结果查询接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClient.OrderRefundQuery(merchantId, merchOrderId, merchRefundId, tradeTime, 
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("订单退款结果查询接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
		} catch (Exception e) {
			System.out.println("订单退款结果查询接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("订单退款结果查询接口测试----ok");
		System.out.println("------------------------------------------------");
	}	
	
	////==================以下接口为特殊行业或定制化的接口========================
	/**
	 * 互联网金融行业银行卡解除绑定接口测试
	 */
	public static void UnboundBankCardTest(String bankAccNo) {
		// 设置参数
		String merchantId = Constants.MERCHANT_ID;
		String tradeTime = Tools.getSysTime();

		// 调用查询接口
		System.out.println("-------互联网金融行业银行卡解除绑定接口测试-------------------------");
		try {
			Xml retXml = new Xml();
			//接口参数请参考TransactionClient的参数说明
			String ret = TransactionClient.UnboundBankCard(merchantId, bankAccNo, tradeTime,
					Constants.MERCHANT_RSA_PRIVATE_KEY, Constants.PAYECO_RSA_PUBLIC_KEY, Constants.PAYECO_URL, retXml);
			if(!"0000".equals(ret)){
				System.out.println("互联网金融行业银行卡解除绑定接口测试失败！：retCode="+ret+"; msg="+retXml.getRetMsg());
				return;
			}
			System.out.println("Status="+retXml.getStatus());
		} catch (Exception e) {
			System.out.println("互联网金融行业银行卡解除绑定接口测试失败！：");
			e.printStackTrace();
			return;
		}
		System.out.println("互联网金融行业银行卡解除绑定接口测试----ok;");
		System.out.println("------------------------------------------------");
	}
	
	public static void main(String[] args) {
		//设置打印日志
		Log.setLogFlag(true);
		
		// 订单查询接口测试
		String orderId = "1445935379582"; //填写已经存在成功下单的商户订单号
//		OrderQueryTest(orderId);
		
		// 订单冲正接口测试
		orderId = "1445935379582"; //填写已经存在成功下单的商户订单号，只有当天支付成功才能冲正
		String amount = "25";	   //冲正额金额需要和订单金额一样
//		OrderReverseTest(orderId, amount);

		// 订单退款申请接口测试
		orderId = "1445935379582"; //填写已经存在成功下单的商户订单号，只有支付成功才能退款申请
		amount = "1";	   //退款的金额不能大于订单金额
//		OrderRefundReqTest(orderId, amount);
		
		// 订单退款结果查询接口测试
		orderId = "1445935379582"; //填写已经存在成功下单的商户订单号，只有支付成功才能退款申请
		String refundId = "1446005809814";      //退款申请号，需要填写退款申请时提交的申请号，退款结果需要在申请的隔天后才能查询到结果
//		OrderRefundQueryTest(orderId, refundId);
		
		
		
		//互联网金融行业银行卡解除绑定接口测试
		String bankAccNo="6227003324126059872";
		UnboundBankCardTest(bankAccNo);
	}
}
