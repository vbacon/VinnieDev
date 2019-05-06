trigger CustomerDocumentTrigger on Customer_Document__c (before insert,after insert, after update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        CustomerDocumentTriggerHandler cdth = new CustomerDocumentTriggerHandler();
        cdth.onBeforeInsert(Trigger.new);
    }
    
     if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
         new CustomerDocumentTriggerHandler().run();
     }
}