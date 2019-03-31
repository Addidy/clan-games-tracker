public class Helper {    
    
    public static void sleep(Long milliSeconds)	{
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do {
            timeDiff = System.now().getTime() - firstTime.getTime();
        } while(timeDiff <= milliSeconds);
	}
    
    //This method logs the IP of the instance the org is running on.
    public static string LogIP(){
        string ip = '';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://icanhazip.com/');
        req.setMethod('GET');
        Http httpReq = new Http();
        HttpResponse res = httpReq.send(req);
        System.debug(res.getBody());
        
        //Value @ 10/01/19 - 10:49AM - 85.222.158.8
        return ip;
    }
}