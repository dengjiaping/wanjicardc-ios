using System;
using System.Text.RegularExpressions;

namespace com.payeco
{
    public class Tools
    {


        /**
         * 检查字符串是否为空；如果字符串为null,或空串，或全为空格，返回true;否则返回false
         * @param str
         * @return
         */
        public static bool isStrEmpty(String str)
        {
            if ((str != null) && (str.Trim().Length > 0))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /**
         *  以字符串的格式取系统时间;格式：YYYYMMDDHHMMSS
         * @return    时间字符串
         */
        public static String getSysTime()
        {
            return DateTime.Now.ToString("yyyyMMddhhmmss");
        }

        /**
         *
         */
        public static long currentTimeMillis()
        {
           // return DateTime.Now.ToString("MMddhhmmssfff");

            DateTime Jan1st1970 = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            return (long)((DateTime.UtcNow - Jan1st1970).TotalMilliseconds);
        }

        /**
         * 检查字符串是否表示金额，此金额小数点后最多带2位
         * @param str   需要被检查的字符串
         * @return ： true－表示金额，false-不表示金额
         */
        public static bool checkAmount(String amount)
        {
            if (amount == null)
            {
                return false;
            }
            String checkExpressions = "^([1-9]\\d*|[0])\\.\\d{1,2}$|^[1-9]\\d*$|^0$";
            Match m = Regex.Match(amount, checkExpressions);
            if (m.Success)
            {
                return true;
            }
            return false;
        }


        /**
         * 获取XML报文元素，只支持单层的XML，若是存在嵌套重复的元素，只返回开始第一个
         * @param srcXML  ： xml串
         * @param element ： 元素
         * @return        ： 元素对应的值
         */
        public static String getXMLValue(String srcXML, String element)
        {
            String ret = "";
            try
            {
                String begElement = "<" + element + ">";
                String endElement = "</" + element + ">";
                int begPos = srcXML.IndexOf(begElement);
                int endPos = srcXML.IndexOf(endElement);

                if (begPos != -1 && endPos != -1 && begPos <= endPos)
                {
                    begPos += begElement.Length;
                    int f = (endPos - begPos);
                    ret = srcXML.Substring(begPos, f);
                }
                else
                {
                    ret = "";
                }
            }
            catch (Exception e)
            {
                ret = "";
                LogPrint.println(e.Message);
            }
            return ret;
        }

    }
}