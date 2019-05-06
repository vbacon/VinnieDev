// Trigger handler class to update the External Id when it is null

Public Class RelationShipTriggerHandler extends TriggerHandler {


    public RelationShipTriggerHandler() {
    
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
    List < Relationship__c > relList = new List < Relationship__c > ();
    for (Relationship__c re: (List < Relationship__c > ) Trigger.new) {
        //Execute this only when the external id is null
        if (re.ExternalId__c == null) {
            Relationship__c rel = new Relationship__c(ID = re.id);
            rel.ExternalId__c = re.id;
            relList.add(rel);
        }
       
        if (relList.size() > 0) {
            update relList;
        }
    
      }
    }
    
    //End updateExternalId
    
    // Method Created By Srini
    public static void cloneContact(List < Relationship__c > newList){
        
        // Maps to Identify different components uniquely
        Map<String,List<Contact>> cloneMap = new Map<String,List<Contact>>();
        //Map<String,String> relationContactIdMap = new Map<String,String>();
        Map<String,Relationship__c> relationMap = new Map<String,Relationship__c>();
        
        List<Contact> toBeClonedContacts = new List<Contact>();
        
        // Mapping Client Account with eligible partner contacts
        for (Relationship__c re: newList ){
            if(re.Client_name__c != null && re.Partner_Name__c != null && re.Owner__c== true && re.Ownership_of_Business__c>0){
                relationMap.put(re.Id,re);
                List<Contact> conList = GetAllField(re.Partner_Name__c);
                if(conList.size()>0){
                    cloneMap.put(re.Id,conList);
                	
                }
            }
        }
        
        //Creating and Editing the new Cloned Contacts
        for(String clientAccId : cloneMap.keySet()){
            for(Contact con :cloneMap.get(clientAccId)){
                Contact cloneContact = con.clone();
                cloneContact.Nested_Owner__c = true;
                cloneContact.AccountId = relationMap.get(clientAccId).Client_name__c;
                cloneContact.ContactExternal_ID__c = null;
                cloneContact.OAC_access__c = '';
                cloneContact.Username__c = null;
                cloneContact.Most_Recent_Password__c = null;
                cloneContact.Control_Person__c= false;
                cloneContact.Account_Access__c = false;
                cloneContact.TCPA_Consent__c = false;
                cloneContact.Date_for_TCPA_Consent__c = null;
                cloneContact.Ownership_of_Business__c = ((cloneContact.Ownership_of_Business__c) * (relationMap.get(clientAccId).Ownership_of_Business__c))/100;
                
                toBeClonedContacts.add(cloneContact);
            } 
        }
        
        insert toBeClonedContacts;
    }
    
    // Method for querying all fields in the contact - Srini
    public static List<Contact> GetAllField(String accID )
    {
        String query ='';
        String SobjectApiName = 'Contact';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        
        String strFields = '';
        
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where AccountId = \''+accID +'\' AND Ownership_of_Business__c > 0 ';
        System.debug('query...'+query);
        List <Contact> conList = Database.query(query);
		return conList;        
    }

}//End class