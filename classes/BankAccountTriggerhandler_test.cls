@isTest
private class BankAccountTriggerhandler_test{

  static testmethod Void testBankAccountTriggerHandler(){
    
  /*Create Bank Accunt Object for Testing */
        
        //Insert 
        Account acct = new Account();
        acct.Name='TestAccount';
        insert acct ;
        
        //Insert 
        BankAccount__c bank = new BankAccount__c();
        bank.name='TestBank';
        bank.Account__c= acct.id;
        insert bank;
        bank = [select ExternalId__c from BankAccount__c where Id=:bank.id];
        System.assertEquals(true, bank.ExternalId__c !=null);     // Checking if we are getting id In assert equal 
        
        //Update 
        bank.name='TestBank1';
        update bank;
        bank= [select ExternalId__c  from BankAccount__c  where Id=:bank.id];
        System.assertEquals(true, bank.ExternalId__c  !=null);     // Checking if we are getting id In assert equal 
        
        
      }
  }