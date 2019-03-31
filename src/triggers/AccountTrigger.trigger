trigger AccountTrigger on Account (before insert, before update) {
	Decimal randomNumber = math.random();
    //System.debug('Trigger instance: '+randomNumber);
    if(Trigger.isInsert){
        System.debug('INSERT Trigger instance: '+randomNumber);
    }
    if(Trigger.isUpdate){
        System.debug('UPDATE Trigger instance: '+randomNumber);
    }
}