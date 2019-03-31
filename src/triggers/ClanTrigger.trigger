//TODO: create trigger handler class and tests for that class
trigger ClanTrigger on Clan__c (before insert, before update, after insert, after update) {
    
    //Limit the amount of clans that can be modified to one at a time to one.
    if (system.isBatch()){Trigger.new[1].addError('Cannot modify more than one clan at a time!');}
    
    if (Trigger.isBefore){
        //Trigger.new[0] = ClashDataManager.IDNewClanData(Trigger.New[0]);
    }
    
    if (Trigger.isAfter && Trigger.isInsert){
        //ClashDataManager.SyncClanAndMemberInfo(Trigger.new[0].name);
    }
}