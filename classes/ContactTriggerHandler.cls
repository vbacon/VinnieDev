// Trigger handler class to update the Contact External Id when it is null

Public Class ContactTriggerHandler extends TriggerHandler {


    public ContactTriggerHandler() {
    
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
    List <Contact> conList = new List <Contact> ();
    for (Contact con: (List < Contact> ) Trigger.new) {
        
        //Execute this only when the external id is null
        if (con.ContactExternal_ID__c== null) {
            Contact ac = new Contact (ID = con.id);
            ac.ContactExternal_ID__c= con.id;
            conList.add(ac);
        }
       
        if (conList.size() > 0) {
            update conList ;
        }
    
      }
    }//End updateExternalId
    

}//End class