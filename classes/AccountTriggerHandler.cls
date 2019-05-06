// Trigger handler class to update the External Id when it is null

Public Class AccountTriggerHandler extends TriggerHandler {


    public AccountTriggerHandler() {
    
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
    List <Account> accList = new List <Account> ();
    for (Account acc: (List < Account > ) Trigger.new) {
        
        //Execute this only when the external id is null
        if (acc.External_ID__c == null) {
            Account ac = new Account (ID = acc.id);
            ac.External_ID__c = acc.id;
            accList.add(ac);
        }
       
        if (accList.size() > 0) {
            update accList ;
        }
    
      }
    }//End updateExternalId
    

}//End class