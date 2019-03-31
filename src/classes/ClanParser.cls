public class ClanParser {

	public class IconUrls {
		public String small {get;set;} 
		public String tiny {get;set;} 
		public String medium {get;set;} 

		public IconUrls(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'small') {
							small = parser.getText();
						} else if (text == 'tiny') {
							tiny = parser.getText();
						} else if (text == 'medium') {
							medium = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'IconUrls consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class League {
		public Integer id {get;set;} 
		public String name {get;set;} 
		public IconUrls iconUrls {get;set;} 

		public League(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'iconUrls') {
							iconUrls = new IconUrls(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'League consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String tag {get;set;} 
	public String name {get;set;} 
	public String type_Z {get;set;} // in json: type
	public String description {get;set;} 
	public Location location {get;set;} 
	public BadgeUrls badgeUrls {get;set;} 
	public Integer clanLevel {get;set;} 
	public Integer clanPoints {get;set;} 
	public Integer clanVersusPoints {get;set;} 
	public Integer requiredTrophies {get;set;} 
	public String warFrequency {get;set;} 
	public Integer warWinStreak {get;set;} 
	public Integer warWins {get;set;} 
	public Integer warTies {get;set;} 
	public Integer warLosses {get;set;} 
	public Boolean isWarLogPublic {get;set;} 
	public Integer members {get;set;} 
	public List<MemberList> memberList {get;set;} 

	public ClanParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'tag') {
						tag = parser.getText();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'type') {
						type_Z = parser.getText();
					} else if (text == 'description') {
						description = parser.getText();
					} else if (text == 'location') {
						location = new Location(parser);
					} else if (text == 'badgeUrls') {
						badgeUrls = new BadgeUrls(parser);
					} else if (text == 'clanLevel') {
						clanLevel = parser.getIntegerValue();
					} else if (text == 'clanPoints') {
						clanPoints = parser.getIntegerValue();
					} else if (text == 'clanVersusPoints') {
						clanVersusPoints = parser.getIntegerValue();
					} else if (text == 'requiredTrophies') {
						requiredTrophies = parser.getIntegerValue();
					} else if (text == 'warFrequency') {
						warFrequency = parser.getText();
					} else if (text == 'warWinStreak') {
						warWinStreak = parser.getIntegerValue();
					} else if (text == 'warWins') {
						warWins = parser.getIntegerValue();
					} else if (text == 'warTies') {
						warTies = parser.getIntegerValue();
					} else if (text == 'warLosses') {
						warLosses = parser.getIntegerValue();
					} else if (text == 'isWarLogPublic') {
						isWarLogPublic = parser.getBooleanValue();
					} else if (text == 'members') {
						members = parser.getIntegerValue();
					} else if (text == 'memberList') {
						memberList = arrayOfMemberList(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ClanParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class MemberList {
		public String tag {get;set;} 
		public String name {get;set;} 
		public String role {get;set;} 
		public Integer expLevel {get;set;} 
		public League league {get;set;} 
		public Integer trophies {get;set;} 
		public Integer versusTrophies {get;set;} 
		public Integer clanRank {get;set;} 
		public Integer previousClanRank {get;set;} 
		public Integer donations {get;set;} 
		public Integer donationsReceived {get;set;} 

		public MemberList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tag') {
							tag = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'role') {
							role = parser.getText();
						} else if (text == 'expLevel') {
							expLevel = parser.getIntegerValue();
						} else if (text == 'league') {
							league = new League(parser);
						} else if (text == 'trophies') {
							trophies = parser.getIntegerValue();
						} else if (text == 'versusTrophies') {
							versusTrophies = parser.getIntegerValue();
						} else if (text == 'clanRank') {
							clanRank = parser.getIntegerValue();
						} else if (text == 'previousClanRank') {
							previousClanRank = parser.getIntegerValue();
						} else if (text == 'donations') {
							donations = parser.getIntegerValue();
						} else if (text == 'donationsReceived') {
							donationsReceived = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'MemberList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class IconUrls_Z {
		public String small {get;set;} 
		public String tiny {get;set;} 

		public IconUrls_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'small') {
							small = parser.getText();
						} else if (text == 'tiny') {
							tiny = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'IconUrls_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BadgeUrls {
		public String small {get;set;} 
		public String large {get;set;} 
		public String medium {get;set;} 

		public BadgeUrls(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'small') {
							small = parser.getText();
						} else if (text == 'large') {
							large = parser.getText();
						} else if (text == 'medium') {
							medium = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BadgeUrls consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class League_Z {
		public Integer id {get;set;} 
		public String name {get;set;} 
		public IconUrls_Z iconUrls {get;set;} 

		public League_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'iconUrls') {
							iconUrls = new IconUrls_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'League_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Location {
		public Integer id {get;set;} 
		public String name {get;set;} 
		public Boolean isCountry {get;set;} 
		public String countryCode {get;set;} 

		public Location(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'isCountry') {
							isCountry = parser.getBooleanValue();
						} else if (text == 'countryCode') {
							countryCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ClanParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ClanParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<MemberList> arrayOfMemberList(System.JSONParser p) {
        List<MemberList> res = new List<MemberList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MemberList(p));
        }
        return res;
    }
    
    
    // ------------------------------- CUSTOM CODE -------------------------------- //
    
    //Constructor
    public ClanParser(String json) {
        ClanParser cp 	= ClanParser.parse(json);
        this.tag 		= cp.tag;
        this.name 		= cp.name;
        this.type_Z 	= cp.type_Z;
        this.description = cp.description;
        this.location 	= cp.location;
        this.badgeUrls 	= cp.badgeUrls;
        this.clanLevel 	= cp.clanLevel;
        this.clanPoints = cp.clanPoints;
        this.clanVersusPoints = cp.clanVersusPoints;
        this.requiredTrophies = cp.requiredTrophies;
        this.warFrequency = cp.warFrequency;
        this.warWinStreak = cp.warWinStreak;
        this.warWins 	= cp.warWins;
        this.warTies 	= cp.warTies;
        this.warLosses 	= cp.warLosses;
        this.isWarLogPublic = cp.isWarLogPublic;
        this.members 	= cp.members;
        this.memberList = cp.memberList;
    }
    
    //Convert clan data into usable Clan__c sObject
    public Clan__c clanSObject {
        get {
            if (name != null){
                Clan__c clan = new Clan__c();
                clan.name = tag;
                clan.name__c = name;                
                return clan;
            } else {
                return null;
            }
        }
    }
    
    public List<Player__c> getMemberPartials(){
        List<Player__c> mp = new List<Player__c>();
        for (MemberList member : memberList) {
            mp.add(new Player__c(
            	Name = member.tag,
                Name__c = member.name,
                Total_Clan_Games_Points__c = 0
            ));
        }
        System.debug(mp);
        return mp;
    }
}