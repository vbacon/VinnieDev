// Trigger handler class to update the External Id when it is null

Public Class RelationShipBATriggerHandler extends TriggerHandler {


    public RelationShipBATriggerHandler() {
    
    }
    
    //All the functionality which needs to be executed afterinsert goes
    // into this method.
    Protected override void afterInsert() {
        updateExternalId();
    }
    
    Protected override void afterUpdate() {
    updateExternalId();
    }
    
 /* private methods */
     /*Method to Update external id on After insert/Update Call*/
     
      private void updateExternalId() {
    List < Relationship_Bank_Account__c> relList = new List < Relationship_Bank_Account__c> ();
    for (Relationship_Bank_Account__c re: (List < Relationship_Bank_Account__c> ) Trigger.new) {
        //Execute this only when the external id is null
        if (re.External_Id__c== null) {
            Relationship_Bank_Account__c rel = new Relationship_Bank_Account__c(ID = re.id);
            rel.External_Id__c= re.id;
            relList.add(rel);
        }
       
        if (relList.size() > 0) {
            update relList;
        }
    
      }
    }
 }