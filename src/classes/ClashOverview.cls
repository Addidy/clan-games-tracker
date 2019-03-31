/* This class is intended to collect data from the org relevant to cgt
 * in order to verify unit tests.*/

public class ClashOverview {
	private static List<Player__c> 				allPlayers;
    private static List<Clan__c> 				allClans;
    private static List<Clan_Games_Event__c> 	allClanGamesEvents;
    
    private static List<Clan_game__c> 				allClanGames;
    private static List<Clan_Game_Contribution__c> 	allClanGameContributions;  
    private static List<Clan_Member_Session__c> 	allClanMemberSessions;
    
    public static void Sync(){
        allPlayers 					= [SELECT id, name, name__c, current_clan_member_session__c, Total_clan_games_points__c FROM Player__c];
        allClans 					= [SELECT id, name, name__c FROM Clan__c];
        allClanGamesEvents 			= [SELECT id, date_start__c, date_end__c FROM Clan_Games_Event__c];
        allClanGames 				= [SELECT id, clan__c, clan_games_event__c FROM Clan_game__c];
        allClanGameContributions 	= [SELECT id, clan_game__c, player__c, total_clan_games_points_at_start__c, total_clan_games_points_at_end__c FROM Clan_Game_Contribution__c];
        allClanMemberSessions 		= [SELECT id, clan__c, player__c, date_time_start__c, date_time_end__c FROM Clan_Member_Session__c];        
    }
    
    public static List<Player__c> 			getAllPlayers(){
        return allPlayers;
    }
    public static List<Clan__c> 			getAllClans(){
        return allClans;
    }
    public static List<Clan_Games_Event__c> getAllClanGamesEvents(){
        return allClanGamesEvents;
    }
    public static List<Clan_game__c> 		getAllClanGames(){
        return allClanGames;
    }
    public static List<Clan_Game_Contribution__c> 	getAllClanGameContributions(){
        return allClanGameContributions;
    }
    public static List<Clan_Member_Session__c> 		getAllClanMemberSessions(){
        return allClanMemberSessions;
    }
    
    public static integer getClanCount(){
        return allClans.size();
    }    
    public static integer getPlayerCount(){
        return allPlayers.size();
    }    
    public static integer getClanMemberSessionsCount(){
        return allClanMemberSessions.size();
    }    
    public static integer getClanGameContribtutionsCount(){
        return allClanGameContributions.size();
    }
    
    public static Map<String, Player__c> getPlayerMapByName(){
        return PlayerCollectionsHelper.MapPlayersByName(allPlayers);
    }    
    public static Map<String, Player__c> getPlayerMapByTag(){
        return PlayerCollectionsHelper.MapPlayersByTag(allPlayers);
    }    
    public static Map<id, Player__c> getPlayerMap(){
        return PlayerCollectionsHelper.MapPlayersById(allPlayers);
    }
    //TODO finish.
}