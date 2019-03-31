public class ClashDataManager implements schedulable {
    /*
     * TODO: (refactorisation)
     * Split the logic in this class into PlayerTriggerHandler & ClanTriggerHandler.
     * (do this first) Reduce the number of arguments needed in functions by turning statics into instantiable classes with member variables
     * 
     */   
    public void Execute(System.SchedulableContext sc) {
        SyncAllClashData();
    }
    
    @InvocableMethod(label='Sync all Clash Data')
    public static void SyncAllClashData(){
        system.debug('Sync all clash data');
        List<Clan__c> clans = [SELECT id, name FROM Clan__c];       //get all the orgs clan's
        
        //deal with clan games events
        List<Clan_Games_Event__c> currentClanGamesEvent = [SELECT id, Date_Start__c, Date_End__c FROM Clan_Games_Event__c WHERE Date_Start__c <= :Utilities.currentDate AND Date_End__c >= :Utilities.currentDate];
        
        if (currentClanGamesEvent.size() > 0){                                                                      //if a clan games event is running/has started...
            //TODO Change this to support a clan being tracked during a clan game
            if([SELECT Id FROM Clan_Game__c].size() == 0){            
                List<Clan_Game__c> newClanGames = new List<Clan_Game__c>();
                for (Clan__c clan : clans)  {                                                                           //for every clan in the org...
                    newClanGames.add(new Clan_Game__c(Clan__c=clan.Id, Clan_Games_Event__c=currentClanGamesEvent[0].Id));                   //insert a clan game record for that clan
                }
                insert newClanGames;
            }
        }
        
        //sync all new clan information
        if (!Test.isRunningTest()) {                                                                            //if we are not running tests...
            for (Clan__c clan : clans)  {
                SyncClanAndMemberInfo(clan.Name);                                                                       //sync clan and member info (using callouts)
            }
        }
    }
    
    public static void SyncClanAndMemberInfo(String clanTag){               //Makes a web service callout chain to get specified clan info and subsequent player information that will sync the information to the org
        QA_ClashDataSynchroniser cds = new QA_ClashDataSynchroniser(clanTag);
        System.enqueueJob(cds);
    }
    
    public static void HandleNewClanInfo(Clan__c clan) {
        //TODO bulkify to handle list of clans in a seperate function
        List<Clan__c> orgClan = [SELECT Id, Name, Name__c FROM Clan__c WHERE name = :clan.Name];
        if (orgClan.size() > 0) {
            clan.id = orgClan[0].id;
        }
        upsert clan;
    }
}