public class AllEmailTasksController {
    public List<Task> taskList{set;get;}
    
    public AllEmailTasksController(ApexPages.StandardController controller){
        this();
    }
    
     
    public AllEmailTasksController(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        if(accId !=null) {
            initializeRecords(accId);
        }
    }
    
    private void initializeRecords(String accId){
        
        Set<Id> contactIds = getContactIds(accId);
        taskList = [SELECT Id, WhoId, WhatId, TaskSubType, Subject, Description, ActivityDate 
            	FROM Task 
            	WHERE TaskSubType = 'email' AND
            		IsVisibleInSelfService = true AND
                	(WhatId = :accId OR WhoId IN :contactIds)];
    }
    
    public PageReference cancel(){
    
        String accId = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+ accId);
    }
    
    private Set<Id> getContactIds (Id acctId) {
        
        Set<Id> contactIds = new Set<Id>();
        List<Contact> contactList = [SELECT Id
            FROM Contact
            WHERE AccountId = :acctId];
        for (Contact c : contactList) {
            contactIds.add(c.Id);	
        }
        return contactIds;
    }
    
}