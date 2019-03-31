@IsTest
public class QA_ClashPlayerDataSynchroniserTest {
	    @istest static void T01_InsertsPlayerData(){        
        Test.setMock(HttpCalloutMock.class, TestData.GenerateClashDataMock());
        List<player__c> players = new List<Player__c>();
        
        insert new Clan__c(name = TestData.CLAN_TAG_1, name__c = 'Max Clan Games');        
        players.add(new Player__c(Name=TestData.PLAYER_TAG_1, Name__c='Addidy', Total_Clan_Games_Points__c=0));
        players.add(new Player__c(Name=TestData.PLAYER_TAG_2, Name__c='Syntax', Total_Clan_Games_Points__c=0));
        
        QA_ClashPlayerDataSynchroniser cpds = new QA_ClashPlayerDataSynchroniser(TestData.CLAN_TAG_1, players);        
        Test.startTest();            
            System.enqueueJob(cpds);            
        Test.stopTest();
        
        List<player__c> orgPlayers = [SELECT Id, Name, Name__c, Total_Clan_Games_Points__c FROM Player__c];
        
        System.assertEquals(2, orgPlayers.size());
        System.assertEquals('Addidy', orgPlayers[0].Name__c);
        System.assert(orgPlayers[0].Total_Clan_Games_Points__c > 0);
    }
}