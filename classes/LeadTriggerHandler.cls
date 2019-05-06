// Trigger handler class to update the Lead  External Id when it is null

Public Class LeadTriggerHandler extends TriggerHandler {

    public LeadTriggerHandler() {
    
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
    List <Lead> ldList = new List <Lead> ();
    for (Lead ld: (List < Lead> ) Trigger.new) {
        
        //Execute this only when the external id is null
        if (ld.ExternalId__c== null) {
            Lead ldObj = new Lead (ID = ld.id);
            ldObj.ExternalId__c= ld.id;
            ldList.add(ldObj);
        }
       
        if (ldList.size() > 0) {
            update ldList ;
        }
    
      }
    }//End updateExternalId
    

}//End class