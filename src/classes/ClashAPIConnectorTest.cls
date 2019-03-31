@IsTest
public class ClashAPIConnectorTest {
    
    @istest static void T01_RequestClanAndMemberInfo(){
        Test.setMock(HttpCalloutMock.class, TestData.GenerateClashDataMock());
        Test.startTest();
        ClanParser cp = ClashAPIConnector.RequestClanAndMemberInfo(TestData.CLAN_TAG_1);        
        Test.stopTest();
        
        System.assertEquals('Max Clan Games', cp.name);
    }
    
    @istest static void T02_RequestPlayerInfo(){        
        Test.setMock(HttpCalloutMock.class, TestData.GenerateClashDataMock());
        Test.startTest();
        	PlayerParser pp1 = ClashAPIConnector.RequestPlayerInfo(TestData.PLAYER_TAG_1);
        	PlayerParser pp2 = ClashAPIConnector.RequestPlayerInfo(TestData.PLAYER_TAG_2);
        Test.stopTest();
        
        System.assertEquals('Addidy', pp1.name); 							//test data was retrieved
        System.assert(pp1.playerSObject.Total_Clan_Games_Points__c > 0);	//points retrieved from data
        System.assert(pp1.getAchievementByName('Games Champion').value > 0);
        
        System.assertEquals('Syntax', pp2.name); 							//test data was retrieved
        System.assert(pp2.playerSObject.Total_Clan_Games_Points__c > 0);	//points retrieved from data
        System.assert(pp2.getAchievementByName('Games Champion').value > 0);
    }
}