@IsTest
public class ClashDataManagerTest {
    
    @istest static void T01_ClanNotDuplicatedOnSync(){
        Clan__c clanData = new Clan__c(name = TestData.CLAN_TAG_1, name__c='Max Clan Games');
        insert clanData.clone();
                
        Test.startTest();
            ClashDataManager.HandleNewClanInfo(clanData.clone());
        Test.stopTest();
        
        List<Clan__c> orgClans = [SELECT Id, Name, Name__c FROM Clan__c];
        
        System.assertEquals(1, orgClans.size());
        System.assertEquals('Max Clan Games', orgClans[0].Name__c);        
    }
        
    //========================CLAN GAMES FUNCTIONALITY=========================//
    
    @istest static void T07_CreateClanGameOnClanGameEventStart(){
        //<setup>//
        //set time to clan games
        Utilities.today = Date.newInstance(2019, 1, 1);																			//set now utility to a time in between those dates
        Utilities.now   = Date.newInstance(2019, 1, 1);
        insert new Clan_Games_Event__c(Date_Start__c=Date.newInstance(2020, 1, 1), Date_End__c=Date.newInstance(2020, 1, 7));	//new clan game event with start and end dates
		insert TestData.CLAN_1.clone();
        
        List<player__c> players = new List<Player__c>();
        Player__c player1 = new Player__c(Name='#P0UUCUYCP', Name__c='Addidy', Total_Clan_Games_Points__c=1000);					//set up player data
        Player__c player2 = new Player__c(Name='#YYU2UVGV0', Name__c='Syntax', Total_Clan_Games_Points__c=500);
        players.add(player1.clone());
        players.add(player2.clone());
        //</SETUP>//
        
        Test.startTest();
        	//--------------------------------------Sync clan data before clan games event starts------------------------------------------//
        	ClashDataManager.SyncAllClashData();	
        	new PlayerTriggerHelper(TestData.CLAN_TAG_1, players).HandleNewPlayerInfo();
        	
        	//collect data
        	List<Clan_Game__c> 				resultClanGames 			= [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
        	//verify results
        	System.assertEquals(0, resultClanGames.size(), 				'Clan Game was not created');
        
        	//-------------------------------Sync clan data after clan games event starts for the first time-------------------------------//
			//<SETUP>//
        	//set time to clan games start
        	Utilities.today = Date.newInstance(2020, 1, 1);																			//set now utility to a time in between those dates
        	Utilities.now   = Date.newInstance(2020, 1, 1);
        	//reset player references
        	players.clear();
        	players.add(player1.clone());
        	players.add(player2.clone());
        	//have the second player accumulate some points since last sync
        	players[1].Total_Clan_Games_Points__c = 1200;
        	//</SETUP>//
        
        	//<TEST>//
        	ClashDataManager.SyncAllClashData();
        	new PlayerTriggerHelper(TestData.CLAN_TAG_1, players).HandleNewPlayerInfo();
        	//</TEST>//
        	
            //<collect result data>//
                                            resultClanGames 				= [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
            List<Clan_Game_Contribution__c> resultClanGameContributions 	= [SELECT Id, player__c, Total_Clan_Games_Points_at_start__c, Total_Clan_Games_Points_at_end__c FROM Clan_Game_Contribution__c];
            List<Player__c> 				resultPlayers					= [SELECT Id, name, name__c FROM Player__c];
            
            Map<String, Clan_Game_Contribution__c> resultContributionsByPlayerTag = PlayerCollectionsHelper.MapContributionsByPlayerTag(resultPlayers, resultClanGameContributions);
            //</collect result data>//
            
            //<VERIFY EXPECTED RESULTS>
            System.assertEquals(1, resultClanGames.size(), 'Clan Game was not created');
        	//</VERIFY EXPECTED RESULTS>//
        	
        	
        	//--------------------------------------------------sync after clan games ends-----------------------------------------//
        	//--------------------------------------------------another clan game begins-------------------------------------------//
        Test.stopTest();
    }
}