public class PlayerCollectionsHelper {
    
    public static Map<id, Player__c> MapPlayersById(List<Player__c> players){
        return new Map<id, Player__c>(players);
    }
    
    public static Map<String, Player__c> MapPlayersByTag(List<Player__c> players){
        Map<String, Player__c> playerMap = new Map<String, Player__c>();
        for (Player__c player : players){
            playerMap.put(player.name, player);
        }
        return playerMap;
    }
    
    public static Map<String, Player__c> MapPlayersByName(List<Player__c> players){
        Map<String, Player__c> playerMap = new Map<String, Player__c>();
        for (Player__c player : players){
            playerMap.put(player.name__c, player);
        }
        return playerMap;
    }
    
    public static Map<String, Clan_Game_Contribution__c> MapContributionsByPlayerTag(List<Player__c> players, List<Clan_Game_Contribution__c> contributions){
        Map<Id, Player__c> playersById = new Map<Id, Player__c>([SELECT Id, name, Name__c FROM player__c]);

        Map<String, Clan_Game_Contribution__c> contributionsByPlayerTag = new Map<String, Clan_Game_Contribution__c>();
        for(Clan_Game_Contribution__c contribution : contributions){
            contributionsByPlayerTag.put(playersById.get(contribution.player__c).name, contribution);
        }
        return contributionsByPlayerTag;
    }
    
    public static Map<Id, Player__c> getExistingPlayersFrom(List<Player__c> players){
    	Map<id, Player__c> existingPlayers = new Map<id, Player__c>();
        for(Player__c player : players){
            if (player.id != null){
                existingPlayers.put(player.id, player);
            }
        }
        return existingPlayers;
    }
    
    public static List<Player__c> getNewPlayersFrom(List<Player__c> players){
        List<Player__c> newPlayers = new List<Player__c>();
        for(Player__c player : players){
            if (player.id == null){
                newPlayers.add(player.clone());
            }
        }
        return newPlayers;
    }
    
    public static List<Player__c> FindClanPlayerInfo(String clanTag){
        return [
            SELECT Id, Name, Name__c, Current_Clan_Member_Session__c, Total_Clan_Games_Points__c 
            FROM Player__c 
            WHERE Current_Clan_Member_Session__r.Clan__r.Name = :clanTag
        ];
    }
    
}