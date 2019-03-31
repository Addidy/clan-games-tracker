public class TestData {
    
    public static final string CURRENT_IP 	= '85.222.158.8';
    public static final string CLAN_TAG_1 	= '#UUJJ99RY'; //# urlencoded to %23
    
    public static final Clan__c CLAN_1 = new Clan__c(name= CLAN_TAG_1, name__c = 'Max Clan Games');    
    
    public static final string PLAYER_TAG_1 = '#P0UUCUYCP';//Addidy PlayerTag
    public static final string PLAYER_TAG_2 = '#YYU2UVGV0';//Syntax PlayerTag
    public static final String PLAYER_TAG_3	= '#PL4Y3RTRE';   
    
    public static final Player__c PLAYER_1 = new Player__c(Name = PLAYER_TAG_1, Name__c = 'Addidy', Total_Clan_Games_Points__c = 0);
    public static final Player__c PLAYER_2 = new Player__c(Name = PLAYER_TAG_2, Name__c = 'Syntax', Total_Clan_Games_Points__c = 0);
    public static final Player__c PLAYER_3 = new Player__c(Name = PLAYER_TAG_3, Name__c = 'Player3', Total_Clan_Games_Points__c = 0);
    public static final List<Player__c> DEFAULT_PLAYERS = new List<Player__c>{PLAYER_1, PLAYER_2, PLAYER_3};
        
    public static MultiStaticResourceCalloutMock GenerateClashDataMock(){
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('https://api.clashofclans.com/v1/clans/%23UUJJ99RY', 'JsonClanData2Players');      	//clan mcg request. # urlencoded to %23
        multimock.setStaticResource('https://api.clashofclans.com/v1/players/%23P0UUCUYCP', 'JsonPlayerData'); 			//player addidy request
        multimock.setStaticResource('https://api.clashofclans.com/v1/players/%23YYU2UVGV0', 'JsonPlayerDataSyntax'); 	//player syntax request
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        return multimock;
    }
    
    public static List<Player__c> GenDefaultPlayers(integer amount){
        List<Player__c> retPlayers = new List<Player__c>();
        for (integer i = 0; i < amount; i++){
            if (DEFAULT_PLAYERS.size() == i){break;}
            retPlayers.add(DEFAULT_PLAYERS[i].clone());
        }
        return retPlayers;
    }
    
    public static List<Player__c> GenDefaultPlayers(List<integer> points){
        List<Player__c> retPlayers = new List<Player__c>();
        for (integer i = 0; i < points.size(); i++){
            if (DEFAULT_PLAYERS.size() == i){break;}
            Player__c p = DEFAULT_PLAYERS[i].clone();
            p.Total_Clan_Games_Points__c = points[i];
            retPlayers.add(p);
        }
        return retPlayers;
    }
}