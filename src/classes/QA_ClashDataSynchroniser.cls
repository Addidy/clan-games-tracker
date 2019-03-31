public class QA_ClashDataSynchroniser implements queueable, Database.AllowsCallouts {
    
    private String clanTag;
    
    public QA_ClashDataSynchroniser(String clanTag) {
        this.clanTag = clanTag;
    }
    
    public void execute(QueueableContext context) {        
        ClanParser clanData = ClashApiConnector.RequestClanAndMemberInfo(clanTag);
        ClashDataManager.HandleNewClanInfo(clanData.clanSObject);
        
        if (!Test.isRunningTest()) 
            System.enqueueJob(new QA_ClashPlayerDataSynchroniser(clanData.tag, clanData.getMemberPartials()));        
    }
}