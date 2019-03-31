public class QA_ClashPlayerDataSynchroniser implements Queueable, Database.AllowsCallouts {

    private String clanTag;
    private List<Player__c> players;
    
    public QA_ClashPlayerDataSynchroniser(String clanTag, List<Player__c> players){
        this.players = players;
        this.clanTag = clanTag;
    }
    
    public void execute(QueueableContext context){        
        List<Player__c> newPlayerDataList = new List<Player__c>();
        for (Player__c player : players) {
            PlayerParser newPlayerData = ClashApiConnector.RequestPlayerInfo(player.name);
            newPlayerDataList.add(newPlayerData.playerSObject);
        }
        PlayerTriggerHelper pt = new PlayerTriggerHelper(clanTag, newPlayerDataList);
        pt.HandleNewPlayerInfo();
    }
}