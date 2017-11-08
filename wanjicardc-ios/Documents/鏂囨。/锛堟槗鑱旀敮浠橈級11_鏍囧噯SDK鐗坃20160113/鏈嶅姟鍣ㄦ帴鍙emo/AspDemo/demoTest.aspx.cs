using System;
using com.merchant.demo;

public partial class demoTest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //DemoTest.Test();
        //DemoTestH5.Test();
        DemoTestSdk.Test();
        //DemoTestSmsApi.Test();
        //DemoTestSmsH5.Test();
        //DemoTestApi.Test();
    }
}