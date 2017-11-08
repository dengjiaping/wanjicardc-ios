using System;

namespace com.payeco
{
    /**
     * 日志打印类；
     * 商户可以根据项目需求进行日志记录方式的修改。
     */
    public class LogPrint
    {
        private static bool bLogFlag = false;  //日志打印标志

        public static void setLogFlag(bool bfalg)
        {
            bLogFlag = bfalg;
        }

        /**
         * 日志打印函数；商户可以根据自己的使用情况，修改日志的打印方式（如调整为log4j）
         * @param str ： 打印内容
         */
        public static void println(String str) {
		    if(bLogFlag){
                System.Diagnostics.Debug.WriteLine(str);
                //System.Console.WriteLine(str);
		    }
	    }
    }
}

