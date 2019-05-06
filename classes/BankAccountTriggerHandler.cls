// Trigger handler class to update the Contact External Id when it is null

Public Class BankAccountTriggerHandler extends TriggerHandler {


    public BankAccountTriggerHandler() {
    
    }
    
    //All the functionality which needs to be executed afterinsert goes
    // into this method.
    Protected override void afterInsert() {
    updateExternalId();
    }
    
    //All the functionality which needs to be executed afterupdate goes
    // into this method.
    Protected override void afterUpdate() {
    updateExternalId();
    }
    
 /* private methods */
 /*Method to update external id */
 
    private void updateExternalId() {
    List <BankAccount__c> bnList = new List <BankAccount__c> ();
    for (BankAccount__c bn: (List < BankAccount__c> ) Trigger.new) {
        
        //Execute this only when the external id is null
        if (bn.ExternalId__c== null) {
            BankAccount__c bc = new BankAccount__c(ID = bn.id);
            bc.ExternalId__c= bn.id;
            bnList.add(bc);
        }
       
        if (bnList.size() > 0) {
            update bnList;
        }
    
      }
    }//End updateExternalId
    

}//End class