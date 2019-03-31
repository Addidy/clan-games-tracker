public class ClashAPIConnector {
    
	private static final string apiToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFkZTY3OGVhLTdlY2EtNGMyNi04OWY2LWIzOGMxOGI0Mjg3NSIsImlhdCI6MTU0NzA3NTUxMiwic3ViIjoiZGV2ZWxvcGVyL2RkODJkZWE5LTU2NTMtOTAyMC03MjViLTFkY2VhNzM2NWUxYiIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjg1LjIyMi4xNTguOCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.byTM8M_khmBlmYO9aktquOdsN6o6YxPluOwfLJDtejgwcf6_xQlRSnxa0MYeGH1-42EQuhz6k5dmdmghV6Gn2g';
    
    public static ClanParser RequestClanAndMemberInfo(String tag){
		//Make api request
        String strippedTag = tag.remove('#');
        String baseURL = 'https://api.clashofclans.com/v1/clans/%23';        
        httpResponse response = callout('GET', BaseURL + strippedTag);
        if (response == null){ 
            return null;
        }           
       	return new ClanParser(response.getBody());
    }    
    
    public static PlayerParser RequestPlayerInfo(string tag){        
        //Make api request
        String strippedTag = tag.remove('#');
        String baseURL = 'https://api.clashofclans.com/v1/players/%23';        
        httpResponse response = callout('GET', BaseURL + strippedTag);        
        if (response == null){
            return null;
        }
        return new PlayerParser(response.getBody());
    }
    
    public static httpResponse callout(String httpMethod, String endpoint){        
        httpRequest req = new httpRequest();			//Instantiate an httpRequest and set the required attributes        
        req.setMethod(httpMethod); 						//Set the http verb being used. (REQUIRED) (GET, POST, PUT, DELETE, HEAD, TRACE)        
        req.setEndpoint(endpoint);						//Set the URI of the 3rd party service (REQUIRED)
        
		//Set required headers
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + apiToken);        
        
        req.setTimeout(120000);							//Adjust the timeout duration (in milliseconds) to deal with slow servers or large payloads       
        
        httpResponse response = new http().send(req);	//Use the HTTP Class to send the httpRequest and receive an httpResponse

        //wait for return response...
        if (response.getStatusCode() == 200) {
            return response;
        } else {
            system.debug(response.toString());
            system.debug(response.getBody());
            return null;
        }
    }
}