trigger RelationShipBATrigger on Relationship_Bank_Account__c(after insert,after update) {
  new RelationShipBATriggerHandler().run();
  }