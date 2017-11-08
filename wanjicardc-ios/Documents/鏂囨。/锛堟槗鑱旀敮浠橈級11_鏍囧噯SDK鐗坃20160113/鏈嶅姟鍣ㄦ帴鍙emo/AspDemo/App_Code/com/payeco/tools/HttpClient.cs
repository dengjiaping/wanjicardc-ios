using System.IO;
using System.Net;
using System;

namespace com.payeco
{

    public class HttpClient
    {

        /// <summary>
        //  获取远程服务器结果
        /// </summary>
        /// <param name="url">请求url</param>
        /// <param name="data">提交参数</param>
        /// <returns>验证结果</returns>
        public string send(String url, String data)
        {
            string veryfy_url = url;

            //获取远程服务器结果
            string responseTxt = send(veryfy_url, data, 60000);

            return responseTxt;
        }

        /// <summary>
        /// 获取远程服务器结果
        /// </summary>
        /// <param name="strUrl">指定URL路径地址</param>
        /// <param name="data">提交参数</param>
        /// <param name="timeout">超时时间设置:单位为毫秒</param>
        /// <returns>服务器结果</returns>
        public string send(string strUrl, String data, int timeout)
        {
            string strResult;
            string responseData;
            try
            {
                HttpWebRequest myReq = (HttpWebRequest)HttpWebRequest.Create(strUrl);
                StreamWriter requestWriter = null;

                myReq.Timeout = timeout;
                myReq.Method = "POST";
                myReq.ServicePoint.Expect100Continue = false;
                myReq.ContentType = "application/x-www-form-urlencoded";
                //POST the data.
                requestWriter = new StreamWriter(myReq.GetRequestStream());
                try
                {
                    requestWriter.Write(data);
                }
                catch (Exception ex2)
                {
                    LogPrint.println(ex2.Message);
                    return null;
                }
                finally
                {
                    requestWriter.Close();
                    requestWriter = null;
                }
                responseData = WebResponseGet(myReq);
                strResult = responseData;
            }
            catch (Exception exp)
            {
                LogPrint.println("错误：" + exp.Message);
                return null;
            }

            return strResult;
        }


        public static string WebResponseGet(HttpWebRequest webRequest)
        {
            StreamReader responseReader = null;
            string responseData = "";
            try
            {
                responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
                responseData = responseReader.ReadToEnd();
            }
            catch
            {
                LogPrint.println("获取返回内容错误");
                return null;
            }
            finally
            {
                webRequest.GetResponse().GetResponseStream().Close();
                responseReader.Close();
                responseReader = null;
            }
            return responseData;
        }
    }
}

