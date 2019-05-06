@isTest
private class ContactTriggerhandler_test{

  static testmethod Void testContactTriggerHandler(){
    
  /*Create Contact Object for Testing */
        
        //Insert 
        Account acct = new Account();
        acct.Name='TestAccount';
        insert acct ;
        
        //Insert 
        Contact cont = new Contact();
        cont.lastname='TestContact';
        cont.AccountId= acct.id;
        insert cont;
        cont= [select ContactExternal_ID__c from Contact where Id=:cont.id];
        System.assertEquals(true, cont.ContactExternal_ID__c!=null);     // Checking if we are getting id In assert equal 
        
        //Update 
        cont.lastname='TestLastname1';
        update cont;
        cont= [select ContactExternal_ID__c from Contact where Id=:cont.id];
        System.assertEquals(true, cont.ContactExternal_ID__c!=null);     // Checking if we are getting id In assert equal 
        
        
      }
  }