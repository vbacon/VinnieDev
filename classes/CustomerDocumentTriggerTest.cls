@isTest
public class CustomerDocumentTriggerTest {
    
    @isTest
    public static void insertCD(){
        
        Customer_Document__c cd = new Customer_Document__c(name='test', Document_Type__c='Property Deed');
        insert cd;
            
    }
}