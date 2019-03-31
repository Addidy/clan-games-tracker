@IsTest
public class QA_ClashDataSynchroniserTest {
	@istest static void T01_InsertsClanData(){
        Test.setMock(HttpCalloutMock.class, TestData.GenerateClashDataMock()); 
        
        QA_ClashDataSynchroniser cds = new QA_ClashDataSynchroniser(TestData.CLAN_TAG_1);        
        Test.startTest();            
            System.enqueueJob(cds);            
        Test.stopTest();
        
        List<Clan__c> orgClans = [SELECT Id, Name, Name__c FROM Clan__c];
        
        System.assertEquals(1, orgClans.size());
        System.assertEquals('Max Clan Games', orgClans[0].Name__c);        
    }
}