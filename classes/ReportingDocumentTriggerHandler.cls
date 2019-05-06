public class ReportingDocumentTriggerHandler {
    
    public void onBeforeInsert(List<Reporting_Document__c> newList){
        for(Reporting_Document__c cd:newList){
            if (cd.name == NULL) {
                 cd.name = cd.Document_Type__c;
            }        
        }
    }
}