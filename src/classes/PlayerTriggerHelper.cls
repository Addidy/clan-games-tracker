public class PlayerTriggerHelper {

    private String clanTag;
    private List<Player__c> newPlayerInfo;
    private List<Player__c> oldPlayerInfo;
    private Clan_Game__c currentClanGame;
    
    public PlayerTriggerHelper(String clanTag, List<Player__c> players){
        Initialize(clanTag, Players);
    }

    public PlayerTriggerHelper Initialize(String clanTag, List<Player__c> players){
        this.clanTag = clanTag;
        this.newPlayerInfo = GiveNewPlayerInfoOrgIds(players);
        this.oldPlayerInfo = PlayerCollectionsHelper.FindClanPlayerInfo(this.clanTag);
        this.currentClanGame = FindCurrentClanGame();
        return this;
    }
    
    private List<Player__c> GiveNewPlayerInfoOrgIds(List<player__c> players){
        Map<String, Player__c> playerMapByTag = PlayerCollectionsHelper.MapPlayersByTag(players);        
        List<Player__c> orgPlayers = [SELECT Id, Name, Name__c, Current_Clan_Member_Session__c, Total_Clan_Games_Points__c FROM Player__c WHERE name IN :playerMapByTag.keyset()]; 
        for (Player__c existingPlayer : orgPlayers){
            playerMapByTag.get(existingPlayer.name).id = existingPlayer.id;
        }        
        return playerMapByTag.values();
    }
    
    private Clan_Game__c FindCurrentClanGame(){
        List<Clan_Game__c> ccg = [
            SELECT id FROM Clan_Game__c 
            WHERE Clan_Games_Event__r.Date_Start__c <= :Utilities.currentDate 
            AND Clan_Games_Event__r.Date_End__c >= :Utilities.currentDate 
            AND Clan__r.name = :clanTag
            LIMIT 1];
        return (ccg.size() > 0) ? ccg[0] : null;
    }
    
    public void HandleNewPlayerInfo() {        
        HandleAddingUpdatingPlayers();			
        HandleClanMemberSessions();
        HandleClanGameContributions();
        HandlePlayersLeaving();
    }
    
	private void HandleAddingUpdatingPlayers(){
       	upsert this.newPlayerInfo;
    }
    
    private void HandleClanMemberSessions(){
        Map<id, Player__c> playersRequiringSession = new map<id, Player__c>(FindNewPlayers());
        If (playersRequiringSession.values().size() > 0){
            List<Clan_Member_Session__c> cmsData = InsertClanMemberSessions();//TODO FIX: violates query action rule
            UpdatePlayersCurrentMemberSessionsWith(cmsData);
        }
    }
    
    //TODO: try optimising this function with oldplayerinfo instead of using the query
    private List<Player__c> FindNewPlayers(){
        Set<id> playerIds = new Map<Id, Player__c>(this.newPlayerInfo).keyset();        
        List<Player__c> newPlayers = [
            SELECT Id, Name, Name__c, Total_Clan_Games_Points__c 
            FROM Player__c 
            WHERE (id IN :playerIds) 
            AND (NOT(Current_Clan_Member_Session__r.Clan__r.name = :clanTag))
        ];
        return newPlayers;
    }
    
    private List<Clan_Member_Session__c> InsertClanMemberSessions() {//violates query command principle
        Id clanId = [SELECT Id FROM Clan__c WHERE name = :clanTag][0].id;
        List<Clan_Member_Session__c> cmsData = new List<Clan_Member_Session__c>();
        for (Player__c playerRequiringSession : FindNewPlayers()){    
            cmsData.add(new Clan_Member_Session__c(
                Date_Time_Start__c = Utilities.now,
                Date_Time_End__c = Utilities.now,
                Player__c = playerRequiringSession.id,
                Clan__c = clanId
            ));
        }
        insert cmsData;
        return cmsData;
    }
    
    private void UpdatePlayersCurrentMemberSessionsWith(List<Clan_Member_Session__c> cmsData){
        Map<id, Clan_Member_Session__c> cmsByPlayerIdMap = new Map<id, Clan_Member_Session__c>();	
        for (Clan_Member_Session__c cms : cmsData) {
            cmsByPlayerIdMap.put(cms.Player__c, cms);
        }
        
        Map<id, Player__c> playersRequiringSession = new map<id, Player__c>(FindNewPlayers());
        for (Player__c player : this.newPlayerInfo) {
            if (playersRequiringSession.keyset().contains(player.Id)) {
                player.Current_Clan_Member_Session__c = cmsByPlayerIdMap.get(player.id).id;
            }
        }
        update this.newPlayerInfo;        
    }
    
    private void HandleClanGameContributions(){        
        if (isClanGameRunning()) {
            List<Clan_Game_Contribution__c> clanGameContributionsToUpsert = new List<Clan_Game_Contribution__c>();            
            
            Map<id, Player__c> continuingPlayers = getContinuingPlayers();            
            Map<id, Clan_Game_Contribution__c> existingClanGameContributions = FindExistingClanGameContributions();
            Map<String, Clan_Game_Contribution__c> contributionsByPlayerTag = PlayerCollectionsHelper.MapContributionsByPlayerTag(this.newPlayerInfo, existingClanGameContributions.values());

            Map<id, Player__c> oldPlayerInfoIdMap = new Map<id, Player__c>(this.oldPlayerInfo);
            for (Player__c player : this.newPlayerInfo) {
                Clan_Game_Contribution__c cgcToAdd = new Clan_Game_Contribution__c();
                    
                if (contributionsByPlayerTag.get(player.name) != null) { //if player already has a contribution
                    contributionsByPlayerTag.get(player.name).Total_Clan_Games_Points_at_end__c	= player.Total_Clan_Games_Points__c;
                    clanGameContributionsToUpsert.add(contributionsByPlayerTag.get(player.name));
                } else if (continuingPlayers.get(player.id) != null) { //if player does not have a contribution but is a continuing member...
                    clanGameContributionsToUpsert.add(new Clan_Game_Contribution__c(
                        Player__c							= player.id,
                        Clan_Game__c						= this.currentClanGame.id,
                        Total_Clan_Games_Points_at_start__c	= oldPlayerInfoIdMap.get(player.Id).Total_Clan_Games_Points__c,
                        Total_Clan_Games_Points_at_end__c	= player.Total_Clan_Games_Points__c
                    ));	
                } else {												//otherwise if the player is new...
                    clanGameContributionsToUpsert.add(new Clan_Game_Contribution__c(
                        Player__c							= player.id,
                        Clan_Game__c						= this.currentClanGame.id,
                        Total_Clan_Games_Points_at_start__c	= player.Total_Clan_Games_Points__c,
                        Total_Clan_Games_Points_at_end__c	= player.Total_Clan_Games_Points__c
                    ));	
                }
            }             
            upsert clanGameContributionsToUpsert;
        }
    }
    
    private boolean isClanGameRunning(){
        return (currentClanGame != Null);
    }
    
    private Map<Id, Player__c> getContinuingPlayers(){        
        Map<Id, Player__c> oldPlayerInfoIdMap = new Map<Id, Player__c>(this.oldPlayerInfo);
        Map<Id, Player__c> newPlayerInfoIdMap = new Map<Id, Player__c>(this.newPlayerInfo);
        Map<Id, Player__c> continuingPlayers = new Map<Id, Player__c>();
        for (Player__c newPlayer : this.newPlayerInfo) {
            if (oldPlayerInfoIdMap.get(newPlayer.id) != null){
                continuingPlayers.put(newPlayer.id, newPlayerInfoIdMap.get(newPlayer.id));
            }
        }
        return continuingPlayers;
    }
    
    private void HandlePlayersLeaving(){
        Map<id, player__c> newPlayerDataMap = new Map<id, player__c>(this.newPlayerInfo);		//get all players currently in the clan (from request)
        Map<id, Player__c> orgPlayers = FindOrgPlayersByClanTag(this.clanTag);						//get all of the players currently in the database
        
        List<player__c> absentPlayers = [SELECT id, current_clan_member_session__c FROM player__c WHERE (id IN :orgPlayers.keyset()) AND (NOT(id IN :newPlayerDataMap.keyset()))];
        if(absentPlayers.size() > 0){														//if there are members no longer in the clan...
            List<id> cmsIds = new List<id>();													//make a store to collect CMS ids
            for (Player__c player : absentPlayers) {											//for every absent clan member...
                cmsIds.add(player.Current_Clan_Member_Session__c);									//get all of these players current clan member sessions and set their end date to now.
                player.current_clan_member_session__c = null;										//set their current clan member session to null
            }
            update absentPlayers;															//unlink all the players from their previous clan member sessions
            
            //update the clan member sessions final time
            List<Clan_member_session__c> cmsList = [SELECT id, Date_Time_End__c FROM Clan_Member_Session__c WHERE id IN :cmsIds];
            for (clan_member_session__c cmsItem : cmsList){
                cmsItem.Date_Time_End__c = Utilities.now;
            }
            update cmsList;
        }
    }
    
    //------------------------------Helpers------------------------------//

    private Map<id, Clan_Game_Contribution__c> FindExistingClanGameContributions(){
        Map<id, Clan_Game_Contribution__c> cgc = new Map<id, Clan_Game_Contribution__c>([
                SELECT id, player__c 
                FROM Clan_Game_Contribution__c 
                WHERE Clan_Game__c = :currentClanGame.id AND Player__c IN :getContinuingPlayers().values()
            ]);
        return cgc;
    }
    
    private Map<Id, Player__c> FindOrgPlayersByClanTag(String clanTag){
        Map<id, Clan_Member_session__c> cmsData = new Map<Id, clan_member_session__c>([SELECT id FROM clan_member_session__c WHERE (clan__r.name = :clanTag) AND (player__r.Current_clan_member_session__c != null)]);
		Map<id, Player__c> players = new Map<Id, Player__c>([SELECT Id, name, name__c, total_clan_games_points__c, current_clan_member_session__c FROM Player__c WHERE current_clan_member_session__c IN :cmsData.keyset()]);
        return players;
    }

}