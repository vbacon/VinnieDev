trigger TriggerOnScore on Score__c (after insert) {
	if(Trigger.isAfter && Trigger.isInsert){
		//TriggerOnScoreController.onAfter(Trigger.New);
	}
}