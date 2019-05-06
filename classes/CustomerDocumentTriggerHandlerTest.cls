@isTest
private class CustomerDocumentTriggerHandlerTest{

  static testmethod Void testCustomer_DocumentTriggerHandler(){
    
  /*Create custom document Object for Testing */
        
        //Insert 
        Account acct = new Account();
        acct.Name='TestAccount';
        insert acct ;
        
        //Insert 
        Customer_Document__c cont = new Customer_Document__c();
        cont.Name='TestCustomerDocument';
        cont.Account__c= acct.id;
        cont.Document_Type__c='Insurance Policy';
        insert cont;
        cont= [select externalId__c from Customer_Document__c where Id=:cont.id];
        System.assertEquals(true, cont.externalId__c !=null);     // Checking if we are getting id In assert equal 
        
        //Update 
        cont.Name='TestCustomerDocname1';
        update cont;
        cont= [select externalId__c from Customer_Document__c where Id=:cont.id];
        System.assertEquals(true, cont.externalId__c !=null);     // Checking if we are getting id In assert equal 
        
        
      }
  }