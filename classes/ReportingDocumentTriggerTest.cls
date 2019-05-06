@isTest
public class ReportingDocumentTriggerTest {
    
    @isTest
    public static void insertCD(){
        
        Reporting_Document__c cd = new Reporting_Document__c(name='test', Document_Type__c='SAR');
        insert cd;
            
    }
    
    @isTest
    public static void inserNullCD(){
        
        Reporting_Document__c cd = new Reporting_Document__c(name=NULL, Document_Type__c='SAR');
        insert cd;
            
    }
}