# roku-purchase-bug
The sample in-app purchase is used to create this sample application. I came across this bug with back button while using this sample application. Before loading the products, if the user hits the back button, it is redirected to the back button but then again sends you the purchased page.

appMain.brs displays an option to move to purchase page. 

The purchase screen takes some time to load the test products from ROKU server. 
This sample application was downloaded from ROKU's blog [https://blog.roku.com/developer/2013/06/06/supporting-in-app-purchases-in-your-roku-brightscript-channels/], hence the purchase flow works good.

While the user is in purchase screen and before the products load if the user hits the back button, the user is taken back to Main screen but after few seconds redirects to success page.

The issue here is once the back button is clicked before the products are loaded, screen is closed for roListScreenEvent but roChannelStoreEvent still continues to go forward with its task which results in redirecting the screen to purchase page.
If the API call is made before the redirection code in roChannelStoreEvent, we can prevent it from redirecting. I am just checking if I can have some option to stop roChannelStoreEvent along side roListScreenEvent once the screen is closed or back button is pressed.
