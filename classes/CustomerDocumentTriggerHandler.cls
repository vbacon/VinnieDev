public class CustomerDocumentTriggerHandler extends TriggerHandler  {
    
    public void onBeforeInsert(List<Customer_Document__c> newList){
        for(Customer_Document__c cd:newList){
            
            cd.name = cd.Document_Type__c;
        }
    }
    
    public CustomerDocumentTriggerHandler() {
    
    }
    
    // Trigger handler class to update the Customer Document External Id when it is null
    // This handler class is developed on March 5 2019
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
        List <Customer_Document__c> customerDocList = new List <Customer_Document__c> ();
        for (Customer_Document__c cusDoc: (List < Customer_Document__c> ) Trigger.new) {
            
            //Execute this only when the external id is null
            if (cusDoc.externalId__c== null) {
                Customer_Document__c cusDocObj = new Customer_Document__c (ID = cusDoc.id);
                cusDocObj.externalId__c= cusDoc.id;
                customerDocList.add(cusDocObj);
            }
           
            
        
          }
          
          try{
                if (customerDocList.size() > 0) {
                    update customerDocList ;
                }
          
          }catch(Exception e){
                
                system.debug('error in update ext id'+e.getMessage()+'-LineNUmber--'+e.getLineNumber());
            
          }
    }//End updateExternalId
}