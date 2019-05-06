@isTest
private class RelationshipBATriggerhandler_test{
    
    static testmethod Void testrelationshipTriggerHandler(){
        
        /*Create RelationShip Object for Testing */
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        BankAccount__c objBankAccount = new BankAccount__c();
        objBankAccount.Account__c = objAccount.Id;
        objBankAccount.Name = 'Test Bank';
        insert objBankAccount;
         
        Relationship_Bank_Account__c rel = new Relationship_Bank_Account__c();
        rel.BankAccount__c = objBankAccount.Id;
        rel.Name = 'test';
        insert rel;
        
        rel.Name ='sss';
        update rel;
        rel= [select External_Id__c from Relationship_Bank_Account__c where Id=:rel.id];
        System.assertEquals(true, rel.External_Id__c !=null);     // Checking if we are getting id In assert equal 
        
    }
}