using System;

namespace com.payeco
{
    public class Base64
    {
        /// <summary>  
        /// Base64±àÂë 
        /// </summary>  
        /// <param name="data"></param>  
        /// <returns></returns>  
        public static string encodeBytes(byte[] data)
        {
            return Convert.ToBase64String(data);
        }


        /// <summary>  
        /// Base64±àÂë 
        /// </summary>  
        /// <param name="Message"></param>  
        /// <returns></returns>  
        public static string EncodingString(string SourceString, System.Text.Encoding Ens)
        {
            return Convert.ToBase64String(Ens.GetBytes(SourceString));
        }


        /// <summary>  
        /// Base64½âÂë
        /// </summary>  
        /// <param name="Message"></param>  
        /// <returns></returns>  
        public static byte[] decode(string SourceString)
        {
            return Convert.FromBase64String(SourceString);
        }  

        /// <summary>  
        /// Base64½âÂë
        /// </summary>  
        /// <param name="Message"></param>  
        /// <returns></returns>  
        public static string DecodingString(string SourceString, System.Text.Encoding Ens)
        {
            byte[] bytes = Convert.FromBase64String(SourceString);
            return Ens.GetString(bytes);
        }  
    }
}
