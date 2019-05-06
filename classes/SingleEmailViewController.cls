public class SingleEmailViewController {
    
    public List<Task> taskList{set;get;}
    public Task theTask {set;get;}
    public Id acctId {set;get;}
    public String contactName {set;get;}
    public List<Attachment> theAttachments {set;get;}
    public Boolean showAttachments {set;get;}
    public List<String> modDescription {set;get;}

    public SingleEmailViewController(ApexPages.StandardController controller){
        this();
    }
    
    public SingleEmailViewController(){
        String taskId = ApexPages.currentPage().getParameters().get('id');
        if(taskId !=null) {
            getTaskData(taskId);
        } else {
        	return;
        }
        acctId = null;
        contactName = null;
        setAccountContactValues(theTask);
        
        theAttachments = [SELECT Id, BodyLength, Name FROM Attachment WHERE ParentId = :taskId];
        showAttachments = (theAttachments.size() != 0) ? true : false;
        
        modDescription = modifyDescription(theTask.Description);
    }
    
    private void getTaskData(String taskId){
        taskList = [SELECT Id, WhoId, WhatId, TaskSubType, Subject, Description, ActivityDate 
            FROM Task 
            WHERE Id =:taskId];
        if (taskList.size() != 0) {
        	theTask = taskList[0];
        }
        
        if ((theTask.Subject).substring(0,6) == 'Email:') {
        		theTask.Subject = (theTask.Subject).substring(7);
        }
        
        if ((theTask.Description) == null) {
        		theTask.Description = '';
        }
    }

    private void setAccountContactValues(Task theTask){
       	if (theTask.WhatId != null) {
        	acctId = theTask.WhatId;
        } else if (theTask.WhoId != null) {
            List<Contact> relatedContact = [SELECT AccountId, Name FROM Contact WHERE Id = :theTask.WhoId];
            if (relatedContact.size() != 0) {
            	contactName = relatedContact[0].Name;
            	acctId = relatedContact[0].AccountId;
            }
        } 
    }
 
    @TestVisible
    private static List<String> modifyDescription(String theDesc) {   
        List<String> modifiedDescription = new List<String>();
        
        if (theDesc == '') {
        	modifiedDescription.add('<No Description>');
        	return modifiedDescription;   
        }
           
        List<String> theDescSplit = theDesc.split('\n');
           
        for (String s : theDescSplit) {  // Find those strings that are not really part of the body and don't add them.
        	if ((s.length() >= 8 && s.substring(0,8) == 'Subject:') ||
            		(s.length() >= 14 && s.substring(0,14) == 'Additional To:') ||
                    (s.length() >= 11 && s.substring(0,11) == 'Attachment:') ||
                    (s.length() >= 3 && s.substring(0,3) == 'CC:') ||
                    (s.length() >= 4 && s.substring(0,4) == 'BCC:') ||
                    (s.length() >= 5 && s.substring(0,5) == 'Body:')) {
                    // Do nothing      	
            } else {
                   modifiedDescription.add(s);
            }
        }
                       
        return modifiedDescription;
    }
    
    public PageReference cancel() {
        return new PageReference('/' + acctId);
    }
      
    
}