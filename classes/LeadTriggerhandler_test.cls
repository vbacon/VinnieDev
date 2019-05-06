@isTest
private class LeadTriggerhandler_test{

  static testmethod Void testLeadTriggerHandler(){
    
  /*Create Account Object for Testing */
        
        Lead ld = new Lead();
        ld.FirstName='TestLead';
		  ld.LastName='TestLeadlast';
        ld.Company='TestCompnaylast';
        insert ld;
        
        //Update 
        ld.FirstName='TestLeadupdate';
		  ld.LastName='TestLeadlast';
        ld.Company='TestCompnaylast';
        update ld;
        ld= [select Externalid__c from Lead where Id=:ld.id];
        System.assertEquals(true, ld.Externalid__c!=null);     // Checking if we are getting id In assert equal 
      }
  }