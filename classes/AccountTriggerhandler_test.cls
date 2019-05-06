@isTest
private class AccountTriggerhandler_test{

  static testmethod Void testAccountTriggerHandler(){
    
  /*Create Account Object for Testing */
        
        Account acc = new Account();
        acc.Name='TestAccount';
        insert acc;
        
        //Update 
        acc.Name='TestLastname1';
        update acc;
        acc= [select External_ID__c from Account where Id=:acc.id];
        System.assertEquals(true, acc.External_ID__c!=null);     // Checking if we are getting id In assert equal 
      }
  }