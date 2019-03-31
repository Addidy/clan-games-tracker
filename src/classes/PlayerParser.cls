public class PlayerParser {

	public class Troops {
		public String name;
		public Integer level;
		public Integer maxLevel;
		public String village;
	}

	public class IconUrls {
		public String small;
		public String tiny;
		public String medium;
	}

	public class League {
		public Integer id;
		public String name;
		public IconUrls iconUrls;
	}

	public class Clan {
		public String tag;
		public String name;
		public Integer clanLevel;
		public BadgeUrls badgeUrls;
	}

	public class Achievements {
		public String name;
		public Integer stars;
		public Integer value;
		public Integer target;
		public String info;
		public String completionInfo;
		public String village;
	}

	public class BadgeUrls {
		public String small;
		public String large;
		public String medium;
	}

	public String tag;
	public String name;
	public Integer townHallLevel;
	public Integer expLevel;
	public Integer trophies;
	public Integer bestTrophies;
	public Integer warStars;
	public Integer attackWins;
	public Integer defenseWins;
	public Integer builderHallLevel;
	public Integer versusTrophies;
	public Integer bestVersusTrophies;
	public Integer versusBattleWins;
	public String role;
	public Integer donations;
	public Integer donationsReceived;
	public Clan clan;
	public League league;
	public List<Achievements> achievements;
	public Integer versusBattleWinCount;
	public List<Troops> troops;
	public List<Troops> heroes;
	public List<Troops> spells;
    
	public static PlayerParser parse(String json) {
		return (PlayerParser) System.JSON.deserialize(json, PlayerParser.class);
	}
    
    // ------------------------------- CUSTOM CODE -------------------------------- //
    
    //Constructor
    public PlayerParser(String json){
        PlayerParser pp = PlayerParser.parse(json);
        this.tag        = pp.tag;
        this.name       = pp.name;
        this.townHallLevel = pp.townHallLevel;
        this.expLevel   = pp.expLevel;
        this.trophies   = pp.trophies;
        this.bestTrophies = pp.bestTrophies;
        this.warStars 	= pp.warStars;
        this.attackWins = pp.attackWins;
        this.defenseWins = pp.defenseWins;
        this.builderHallLevel = pp.builderHallLevel;
        this.versusTrophies = pp.versusTrophies;
        this.bestVersusTrophies = pp.bestVersusTrophies;
        this.versusBattleWins = pp.versusBattleWins;
        this.role 		= pp.role;
        this.donations 	= pp.donations;
        this.donationsReceived = pp.donationsReceived;
        this.clan 		= pp.clan;
        this.league 	= pp.league;
        this.achievements = pp.achievements;
        this.versusBattleWinCount = pp.versusBattleWinCount;
        this.troops     = pp.troops;
        this.heroes		= pp.heroes;        
    }
    
    public Achievements getAchievementByName(String name) {
        for (Achievements achievement : achievements) {
            if (achievement.name == name) {
                return achievement;
            }
        }
        return null;
    }
    
    //Convert player data into usable Player__c sObject
    public Player__c playerSObject {
        get{
            if (name != null){
                Player__c player = new Player__c();
                player.name = tag;
                player.name__c = name;
                player.Total_Clan_Games_Points__c = getAchievementByName('Games Champion').value;
                return player;
            } else {
                System.debug('NOT recognised data');
                return null;
            }//*/
        }
    }
}