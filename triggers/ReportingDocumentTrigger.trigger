trigger ReportingDocumentTrigger on Reporting_Document__c (before insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        ReportingDocumentTriggerHandler cdth = new ReportingDocumentTriggerHandler();
        cdth.onBeforeInsert(Trigger.new);
    }
}