@isTest
private class RelationshipTriggerhandler_test{
    
    static testmethod Void testrelationshipTriggerHandler(){
        
        /*Create RelationShip Object for Testing */
        Account clientAcc = new Account(name ='testabcd');
        insert clientAcc;
        
        Account partnerAcc = new Account(name ='testabcd2');
        insert partnerAcc;
        
        Contact con = new Contact(AccountId=partnerAcc.id,email='test@abcd.com',MobilePhone='5555555555',Ownership_of_Business__c=2.00, lastname='Test L Name');
        insert con;
        
        Relationship__c rel = new Relationship__c();
        rel.First_Name__c='Testrel';
        rel.Partner_Name__c = partnerAcc.id;
        rel.Client_name__c = clientAcc.Id;
        rel.Owner__c = true;
        rel.Ownership_of_Business__c = 4;
        insert rel;
        
        rel.Last_Name__c='sss';
        update rel;
        rel= [select ExternalId__c from Relationship__c where Id=:rel.id];
        System.assertEquals(true, rel.ExternalId__c!=null);     // Checking if we are getting id In assert equal 
        
    }
}