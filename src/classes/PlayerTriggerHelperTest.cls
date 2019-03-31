@IsTest
public class PlayerTriggerHelperTest {
    
    @istest static void T02_PlayerNotDuplicatedOnSync(){		
        insert TestData.CLAN_1;
        insert TestData.GenDefaultPlayers(2);
                
        Test.startTest();
        	PlayerTriggerHelper pt = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pt.HandleNewPlayerInfo();
        Test.stopTest();
        
        ClashOverview.Sync();        
        System.assertEquals(2, ClashOverview.getPlayerCount());
        System.assert(ClashOverview.getPlayerMapByName().get('Addidy') != null);
        System.assert(ClashOverview.getPlayerMapByName().get('Syntax') != null);
    }
    
    @istest static void T03_GenerateClanMemberSessions(){
        insert TestData.CLAN_1;
               
        Test.startTest(); 
        	Utilities.now = DateTime.newInstance(2020, 1, 1, 0, 0, 0);
        	PlayerTriggerHelper pt = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pt.HandleNewPlayerInfo();
        Test.stopTest();
        
        ClashOverview.Sync();        
        System.assertEquals(2, ClashOverview.getClanMemberSessionsCount());
        for (Clan_Member_Session__c cms : ClashOverview.getAllClanMemberSessions()) {
            System.assertEquals(Utilities.now, cms.Date_Time_Start__c, 						'Time not correctly set');
            System.assertEquals(Utilities.now, cms.Date_Time_End__c,   						'Time not correctly set');
           	System.assert(ClashOverview.getPlayerMap().keyset().contains(cms.Player__c),  	'Player id is not set on clan member session');
            System.assertEquals(ClashOverview.getAllClans()[0].id, cms.Clan__c, 			'Clan id is not set on clan member session');
            System.assertEquals(cms.id, ClashOverview.getPlayerMap().get(cms.Player__c).current_clan_member_session__c, 'Player\'s clan member session not correctly set');
        }
    }
    
    @istest static void T04_SessionNotDuplicateOnSync() {
        insert TestData.CLAN_1;
                
        Test.startTest();
        	PlayerTriggerHelper pth = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pth.HandleNewPlayerInfo();
        
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pth.HandleNewPlayerInfo();
        Test.stopTest();

        ClashOverview.Sync();        
        System.assertEquals(2, ClashOverview.getClanMemberSessionsCount());
        System.assertEquals(2, ClashOverview.getPlayerCount());
        System.assertEquals(1, ClashOverview.getClanCount());
    }
  
    //end of clashoverview refactoring
    
    @istest static void T05_HandlePlayerLeave() {        
        insert TestData.CLAN_1;
        
        Test.startTest();
        	PlayerTriggerHelper pth = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pth.HandleNewPlayerInfo();
            
            //check the current clan member session exists with expected values for player to be kicked
            ClashOverview.Sync();//this would need a getClanMemberSession by id?
        	//ClashOverview.getPlayerMapByTag().get(TestData.PLAYER_TAG_2).id;
            id cmsId = [SELECT Current_Clan_Member_Session__c FROM Player__c WHERE name=:TestData.PLAYER_TAG_2 LIMIT 1].Current_Clan_Member_Session__c;
            Clan_Member_Session__c cms = [SELECT id, Date_Time_Start__c, Date_Time_End__c FROM Clan_Member_Session__c WHERE (Player__r.name=:TestData.PLAYER_TAG_2) AND (id=:cmsId) LIMIT 1];            
            System.assertEquals(cms.Date_Time_Start__c, cms.Date_Time_End__c, 'the cms entered does not have matching times on start and end dates');        
            
            Utilities.now = DateTime.newInstance(2020, 1, 1, 0, 0, 0);                  //delay the time by a minute before deleting the player

        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(1));
        	pth.HandleNewPlayerInfo();
        Test.stopTest();        
        
        //check the clan member session for the player after they have been 'kicked'
        ClashOverview.Sync();
        Player__c resultPlayer = [SELECT id, Current_Clan_Member_Session__c FROM Player__c WHERE name=:TestData.PLAYER_TAG_2 LIMIT 1];
        Clan_Member_Session__c resultCms = [SELECT id, Date_Time_Start__c, Date_Time_End__c, player__c, clan__r.name FROM Clan_Member_Session__c WHERE Player__c =:resultPlayer.Id AND (id=:cmsId) LIMIT 1];
        
        //change tests
        System.assertEquals(null, resultPlayer.Current_Clan_Member_Session__c, 	 'Player has not been disconnected from the clan');
        System.assert(resultCms.Date_Time_Start__c < resultCms.Date_Time_End__c, 'time has not passed');        
        //cms data intact?
        System.assertEquals(resultPlayer.id, resultCms.Player__c, 		 'CMS no longer referencing correct id');
        System.assertEquals(TestData.CLAN_TAG_1, resultCms.Clan__r.name, 'CMS no longer referencing correct clan');
    }
    
    @istest static void T06_PlayerRejoins(){
        //setup
        insert TestData.CLAN_1;
        
        Test.startTest();
        	//-----------------------------------Setup initial 2 players in clan-----------------------------------//
        	PlayerTriggerHelper pth = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
        	pth.HandleNewPlayerInfo();
			
        	//----------------------------------Simulate player leaving the clan-----------------------------------//
        	Utilities.now = DateTime.newInstance(2020, 1, 1, 0, 1, 0); 	//delay the time by a minute before deleting the player
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(1));
            pth.HandleNewPlayerInfo();
        	
        	//---------------------------------Simulate player rejoining the clan-------------------------------//
        	Utilities.now = DateTime.newInstance(2020, 1, 1, 0, 2, 0); 	//delay the time by a minute before re-adding the player
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(2));
            pth.HandleNewPlayerInfo();
		Test.stopTest();
        
        //collect data for testing
        ClashOverview.Sync();
        List<Player__c> 				orgPlayers 	= [SELECT id, Name, Name__c, Current_Clan_Member_Session__c FROM Player__c];
        Player__c 						rJoinPlayer = [SELECT id, Name, Name__c, Current_Clan_Member_Session__c FROM Player__c WHERE name =: TestData.PLAYER_TAG_2];
        List<Clan_Member_Session__c> 	orgCMS 		= [SELECT id, clan__c, player__c, date_time_start__c,date_time_end__c FROM clan_member_session__c];
        Clan_Member_Session__c          rJPCMS		= [SELECT id, clan__c, player__c, date_time_start__c,date_time_end__c FROM clan_member_session__c WHERE id  =: rJoinPlayer.Current_Clan_Member_Session__c AND player__c=:rJoinPlayer.Id];
        Clan_Member_Session__c          rJPOldCMS   = [SELECT id, clan__c, player__c, date_time_start__c,date_time_end__c FROM clan_member_session__c WHERE id !=: rJoinPlayer.Current_Clan_Member_Session__c AND player__c=:rJoinPlayer.Id];
        
        //verify results
        System.assertEquals(3, orgCMS.size(), 								  'Incorrect amount of clan member sessions generated');
        System.assert(rJoinPlayer.Current_Clan_Member_Session__c != null, 	  'rejoined player does not have a clan member session set');
        System.assert(rJPOldCMS.date_time_end__c < rJPCMS.date_time_start__c, 'rejoined player\'s current clan member session is not ahead of old one');
    }
    
    //========================CLAN GAMES FUNCTIONALITY=========================//
    
    @istest static void T07_CreateClanGameAndContributionsOnClanGameEventStart(){
        //<setup>//
        //set time to clan games
        Utilities.today = Date.newInstance(2019, 1, 1);																			//set now utility to a time in between those dates
        Utilities.now   = Date.newInstance(2019, 1, 1);
        insert new Clan_Games_Event__c(Date_Start__c=Date.newInstance(2020, 1, 1), Date_End__c=Date.newInstance(2020, 1, 7));	//new clan game event with start and end dates
		insert TestData.CLAN_1.clone();
        //</SETUP>//
        
        Test.startTest();
        	//--------------------------------------Sync clan data before clan games event starts------------------------------------------//
        	ClashDataManager.SyncAllClashData();
        	PlayerTriggerHelper pth = new PlayerTriggerHelper(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(new List<Integer>{1000, 500}));
        	pth.HandleNewPlayerInfo();
        	
        	//collect data
        	ClashOverview.Sync();
        	List<Clan_Game__c> resultClanGames = [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
        	//verify results
        	System.assertEquals(0, resultClanGames.size(), 'Clan Game was not created');
        
        	//-------------------------------Sync clan data after clan games event starts for the first time-------------------------------//
			//<SETUP>//
        	//set time to clan games start
        	Utilities.today = Date.newInstance(2020, 1, 1);																			//set now utility to a time in between those dates
        	Utilities.now   = Date.newInstance(2020, 1, 1);
        	//</SETUP>//
        
        	//<TEST>//
        	ClashDataManager.SyncAllClashData();
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(new List<Integer>{1000, 1200}));
        	pth.HandleNewPlayerInfo();
        	//</TEST>//
        	
            //<collect result data>//
            ClashOverview.Sync();
                                            resultClanGames 				= [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
            List<Clan_Game_Contribution__c> resultClanGameContributions 	= [SELECT Id, player__c, Total_Clan_Games_Points_at_start__c, Total_Clan_Games_Points_at_end__c FROM Clan_Game_Contribution__c];
            List<Player__c> 				resultPlayers					= [SELECT Id, name, name__c FROM Player__c];
            
            Map<String, Clan_Game_Contribution__c> resultContributionsByPlayerTag = PlayerCollectionsHelper.MapContributionsByPlayerTag(resultPlayers, resultClanGameContributions);
            //</collect result data>//
            
            //<VERIFY EXPECTED RESULTS>
            System.assertEquals(1, resultClanGames.size(), 				'Clan Game was not created');
            System.assertEquals(2, resultClanGameContributions.size(), 	'Player Clan Game Contributions were not created');
            System.assertEquals(1000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(500, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(1000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_end__c);
            System.assertEquals(1200, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_end__c);
        	//</VERIFY EXPECTED RESULTS>//
        	//--------------------------------------------------another sync with general progression---------------------------------------//      	
        	//<TEST>//
        	ClashDataManager.SyncAllClashData();
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(new List<Integer>{2000, 1200}));
        	pth.HandleNewPlayerInfo();
        	//</TEST>//
        	//<COLLECT RESULT DATA>//
        	ClashOverview.Sync();
        	resultClanGames 				= [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
            resultClanGameContributions 	= [SELECT Id, player__c, Total_Clan_Games_Points_at_start__c, Total_Clan_Games_Points_at_end__c FROM Clan_Game_Contribution__c];
            resultPlayers					= [SELECT Id, name, name__c FROM Player__c];
        	//reset result contributions by player tag
        	resultContributionsByPlayerTag = PlayerCollectionsHelper.MapContributionsByPlayerTag(resultPlayers, resultClanGameContributions);
        	//</COLLECT RESULT DATA>//
        	//<VERIFY>//
        	System.assertEquals(1, resultClanGames.size(), 				'Unexpected amount of clan games');
            System.assertEquals(2, resultClanGameContributions.size(), 	'Unexpected amount of Clan Game Contributions');
        	System.assertEquals(1000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(500, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(2000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_end__c);
            System.assertEquals(1200, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_end__c);
        	//</VERIFY>/*/
        	//--------------------------------------------------new player joins during clan games---------------------------------------//      	
            //<TEST>//
            ClashDataManager.SyncAllClashData();
        	pth.Initialize(TestData.CLAN_TAG_1, TestData.GenDefaultPlayers(new List<Integer>{2000, 1200, 1234}));
        	pth.HandleNewPlayerInfo();
            //</TEST>//
            //<COLLECT RESULT DATA>//
            ClashOverview.Sync();
        	resultClanGames 				= [SELECT Id, Clan__c, Clan_Games_Event__c FROM Clan_Game__c];
            resultClanGameContributions 	= [SELECT Id, player__c, Total_Clan_Games_Points_at_start__c, Total_Clan_Games_Points_at_end__c FROM Clan_Game_Contribution__c];
            resultPlayers					= [SELECT Id, name, name__c FROM Player__c];
        	//reset result contributions by player tag
        	resultContributionsByPlayerTag = PlayerCollectionsHelper.MapContributionsByPlayerTag(resultPlayers, resultClanGameContributions);
            //</COLLECT RESULT DATA>//
            //<VERIFY>//
            //existing information is not modified
        	System.assertEquals(1, resultClanGames.size(), 				'Unexpected amount of clan games');            
        	System.assertEquals(1000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(500, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_start__c);
            System.assertEquals(2000, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_1).Total_Clan_Games_Points_at_end__c);
            System.assertEquals(1200, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_2).Total_Clan_Games_Points_at_end__c);
        	//new information is correct
        	System.assertEquals(3, resultClanGameContributions.size(), 	'Unexpected amount of Clan Game Contributions');
        	System.assertEquals(1234, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_3).Total_Clan_Games_Points_at_end__c);
            System.assertEquals(1234, resultContributionsByPlayerTag.get(TestData.PLAYER_TAG_3).Total_Clan_Games_Points_at_end__c);
            //</VERIFY>/*/
        	//--------------------------------------------------sync after clan games ends-----------------------------------------//
        	//--------------------------------------------------another clan game begins-------------------------------------------//
        Test.stopTest();
    }
    
    /*@istest static void T08_CreateClanGameOnClanGameEventStart(){
        //System.assert(false, 'Test is still a WIP');//TODO remove when test has finished being written.
    }//*/
    
    /*
    CLAN GAMES FUNCTIONALITY
	Don't duplicate clan game contributions points
	create clan game for all clans when clan game event starts
    update clan games contributions on changes
     
    CRON JOBS
    Schedule daily synchronization when clan games is not scheduled
    schedule hourly synchronization when clan games is running
    
    WEBSCRAPING CLAN GAME EVENTS
    if no future clan games scheduled, search for a clan games (done every sync attempt a clan game isn't running)
    insert clan game event if found (provided no overlap with existing data)
    
    ALT SHARING
    keep track of what accounts are related (lookup)
    pool points together in analytics
    
    SYSTEM TO UPLOAD HISTORICAL DATA
    
    ANALYTICS
    
    OTHER CONSIDERATIONS
    what happens when sync attemps fail?
	exploit: if a player contributes to another clans clan games it becomes unclear (if they left) if it was for another clan. 
			I don't have any ideas on how to counter this scenario so far without some sort of manual intervention.
    
    THOUGHT LOG
    restructure queueable apex into a heirarchy
    QA_ClashDataSynchroniser
    -QA_ClashClanGameDataSynchroniser
    -QA_ClashClanDataSynchroniser
    -QA_ClashPlayerDataSynchroniser
    
    The parent will call all three in sequential order and only call the next after the previous function has finished (check if this can be done)

	The cron job for checking if a new clan game is out should be on a seperate cycle for syncing clan games data

	Need to change timestamps on clan games events to datetime rather than current "Date"

	prepare for early farmers we need a presync of the clan state just before clan games start and a relatively fast sync cycle for the first day.

	TEST UNIT TEMPLATE
    //<SETUP>//
    //</SETUP>//        	
    //<TEST>//    
    //</TEST>//
    //<COLLECT RESULT DATA>//
    //</COLLECT RESULT DATA>//
    //<VERIFY>//
    //</VERIFY>//
    */
}