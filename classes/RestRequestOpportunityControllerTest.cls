@IsTest
public class RestRequestOpportunityControllerTest {
    static
    {    
        //Insert Custom Setting for Our EndPoint Api 
        RestRequestCustomSetting__c objRestCustomSetting =new RestRequestCustomSetting__c();
        objRestCustomSetting.name='test';
        objRestCustomSetting.EndPoint__c='http://d6a7fddf.ngrok.io';
        insert objRestCustomSetting;
        RestRequestOpportunityController.SERVICE_URL=objRestCustomSetting.EndPoint__c; 
        //Assert for condition Matching
        System.Assert(String.isNotBlank(objRestCustomSetting.id), 'The Test Custom Setting did not insert properly, please check validation rules and other mechanisms');         
    }
    public static testMethod void unitTest(){
    
        //Insert Dummy Records for Our Api Parameter's 
        Account objAccount =new Account();
            objAccount.name='test';
            insert objAccount;

        Opportunity objOpportunity=new Opportunity();
            objOpportunity.name='test';
            objOpportunity.StageName='Closed Won';
            objOpportunity.CloseDate=Date.Today();
            objOpportunity.accountid=objAccount.id;
            insert objOpportunity;        

        PageReference pageRef = Page.remoteDocumentRequestOpportunity;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(objOpportunity.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        //Intilize Our API Apex Class
        RestRequestOpportunityController objRest =new RestRequestOpportunityController(sc);

        Test.startTest();        
         //Call Mock Data
             System.Test.setMock(HttpCalloutMock.class, new MockData()); 
         //Call Api Method
             objRest.autoRun();
        Test.stopTest();
        //Assert for condition Matching
        System.Assert(String.isNotBlank(objOpportunity.id), 'The Test Opportunity did not insert properly, please check validation rules and other mechanisms');
        
    }
}