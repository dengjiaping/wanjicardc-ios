package com.merchant.demo;

/**
 * @author
 */
/**
 * @author
 */
public class Constants {
  //----商户信息：商户根据对接的实际情况对下面数据进行修改； 以下数据在测试通过后，部署到生产环境，需要替换为生产的数据----
  //商户编号，由易联产生，邮件发送给商户
  public static final String MERCHANT_ID = "302020000058";   //内部测试商户号，商户需要替换该参数
//  public static final String MERCHANT_ID = "002020000008";     //互联网金融行业的商户号
  //商户接收订单通知接口地址（异步通知）；
  public static final String MERCHANT_NOTIFY_URL = "http://www.xxxxx.com/Notify.do";
  //商户接收订单通知接口地址(同步通知),H5版本对接需要该参数；
  public static final String MERCHANT_RETURN_URL = "http://127.0.0.1:8080/ReturnH5.do";
  //商户RSA私钥，商户自己产生（可采用易联提供RSA工具产生）
  public static final String MERCHANT_RSA_PRIVATE_KEY = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOAqNu0SFh5Ksz8Mp/vzm1kxiMYoSREXNXGajCHkKJIVwTaxtPaPYq3JiASZbCALrjp9UM0jLsqayDzF51paUt5lbBDRgqabAClUos3X4c7v2uUt98ILDi8ABQV8BrMZE5RKaLcvvr3mhu/JhabXBz2SBflSCSG3K8HQRTDjjp7nAgMBAAECgYBg01suQ6WyJ+oMzdaxiaQMfszpavVEoJXBIFRvPzIXB7aRfWkBJyYkkuxhsDN4FBOJyB9ivFO1x+298m3gJSutfXfSRA9Kq9XrEIQDjJB4PBx8yTVmVckgCJlsWnhuySHf7gapLkfLHQ+GgiUpYUPW0MJczsu7juuMUZdKHJ6rIQJBAPVLJAxXQYI2e8WMfTPR1jqeZXSQ5r4XI0d8wKFMDa68gq3Y3B2CKmWO16faxafJ8oUWJtJJwRQT6YItBVA3DWUCQQDp8vymxQkLCVpyQ+SfG0Ab9mw2G7p2Y3pAYwms7SIOILoADUbJl2UxpyROj9N9Lq2ndZ0rNIWw4iJXigwRuaxbAkEAkiN7TZLqp25YXUCvEyFwFapq3YC6yAO29A9CIJbUDAepf3OU6Eu1gJ4So6F2YtmxEFM7O8vPKWwXkYPLB5hU9QJAHLjWR+s81vwI/KpVMSt5TXWNh38T/2DrK2h9UZuzaKSf8U2v+SP7KoNos7R4tI+8hiisaReDqlm4+aJbJPn0rQJBAK0EQLyG8iks7Ppclq9UBgEx2iKSsg9y60aSt1YwI73wEdW18paBtoUMjQ5GAqCyVmEb01IY6Kn1si43zqHct4o=";
  //---互联网金融测试商户RSA私钥（从证书文件导出）
//  public static final String MERCHANT_RSA_PRIVATE_KEY = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKpZJ9Rbd9LKg5jM4byOjLfGV2kFqctWDyAQNy+b0rFWOq8D+okjvLRGaRzUjuX28B9a03OmEwL7CW6WloCxr/g9t9WP5aGg1DKEb6biw/bsEDzG5681P39bv/ZlWTjfbg1KjDBaRqqjXK5l7XBAxxWFE7PaH6DuP+5kPR+IKiRbAgMBAAECgYAfDloAkRxrRZhwRwnwglyNNI/DCdFGzM29Hrew6kujIQFZ3vPSBL3mb9/B7c6PhlGIpdpe/ywAIxw5GSMfG0XlQ6umgPSsxF6TaRCXkBE1B1QYn5L4jVgHkszTRMCXkTybtaxEqEh6nhA6Krj4Y5ki1wpDpwHToTUYwz3RHuxdgQJBAN8hkxIhQ0ERALsrOWRZoishT9Ci5BxUtCYwKKw4Und1w3ywvxT28kDO2tp8aZ9/JVcHcRW04I+MmS0ZEPzGYNECQQDDcRpeVL6DLC/+fWhsUK6PixSmfH+roZURpJXlRPmQlxQwluoaQ2b/KUouujycnsphXIIpWHCZenfrJrS1yB1rAkBgU/lPOWb0fyempil3xi55mj7/3mLGTFcdqWrVttb7Va7YdOF5Zob9LZBUBKQAxH5VTRQn/9d2gYdbbdfkmKwRAkEAljVaP7/AAE64wE4gMIc98kLBZ0duVDnGuR2WuvPtHuyObt2+JNtC0L8qLYmjRfhgsL2JqD85oyvV+Jvx7XhU6wJBALIT5T+T3HdFRXlRAH12X74VXOnfHZ79sU/NNDBBtRN2AKfNo/I9g9xV7hZiVGTWEuDK8NImWYBU33PejWCZdS8="; //互联网金融



  //----易联信息： 以下信息区分为测试环境和生产环境，商户根据自己对接情况进行数据选择----
  //易联服务器地址_测试环境
  public static final String PAYECO_URL = "https://testmobile.payeco.com";
  //易联服务器地址_生产环境
  //public static final String PAYECO_URL = "https://mobile.payeco.com";

  //订单RSA公钥（易联提供）_测试环境
  public static final String PAYECO_RSA_PUBLIC_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCRxin1FRmBtwYfwK6XKVVXP0FIcF4HZptHgHu+UuON3Jh6WPXc9fNLdsw5Hcmz3F5mYWYq1/WSRxislOl0U59cEPaef86PqBUW9SWxwdmYKB1MlAn5O9M1vgczBl/YqHvuRzfkIaPqSRew11bJWTjnpkcD0H+22kCGqxtYKmv7kwIDAQAB";
  //订单RSA公钥（易联提供）_生产环境
  //public static final String PAYECO_RSA_PUBLIC_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoymAVb04bvtIrJxczCT/DYYltVlRjBXEBFDYQpjCgSorM/4vnvVXGRb7cIaWpI5SYR6YKrWjvKTJTzD5merQM8hlbKDucxm0DwEj4JbAJvkmDRTUs/MZuYjBrw8wP7Lnr6D6uThqybENRsaJO4G8tv0WMQZ9WLUOknNv0xOzqFQIDAQAB";

}
