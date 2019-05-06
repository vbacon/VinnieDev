trigger RelationShipTrigger on Relationship__c (after insert,after update) {
  new RelationShipTriggerHandler().run();
  if(trigger.isAfter && trigger.isInsert)
    RelationShipTriggerHandler.cloneContact(trigger.new);
}