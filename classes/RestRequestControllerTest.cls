/**
*  @Description: This class is used to Check the functionality of "RestRequestController" class.
*/
@isTest
public class RestRequestControllerTest {
    
   public static final Integer TOTALRECORDS = 1;
   
   /**
   *@description - Create test records that are used while testing 'RestRequestController' class.
   */
    @testSetup
    public static void createTestData() {
        
        List<Account> accountList = new List<Account>();
        
        //Insert Account records
        for(Integer index = 0 ; index < TOTALRECORDS ; index ++){
            accountList.add(new Account(Name = 'Test_Account1'));
        }
        
        INSERT accountList ;
        
        System.assertEquals( TOTALRECORDS, [SELECT count() FROM Account]);
    }   
    
     /**
     *  @description : Test the functionality of RestRequestController class and its methods.
     */
    public static testmethod void autoRunTest(){
        
        List<Account> accountList = new List<Account>();  
        
        // Get Account records
        accountList = [SELECT Id
                       FROM Account];
        
        System.Test.setMock(HttpCalloutMock.class, new RestRequestControllerTestMock()); 
        
        Test.startTest();
        
            // Set pageReference of 'remoteDocumentRequest' vf page
            PageReference pageReference = Page.remoteDocumentRequest;
            Test.setCurrentPage(pageReference);
        
            // Put 'Id' parameter
            ApexPages.currentPage().getParameters().put('Id',accountList[0].Id);
            
            // Create Object of 'RestRequestController' class and call its method to testing the functionality of it.
            ApexPages.StandardController standerdControllerObj = new ApexPages.StandardController(accountList[0]);
            RestRequestController RestRequestControllerObj = new RestRequestController(standerdControllerObj);
            RestRequestControllerObj.autoRun();
        
        Test.stopTest();
    }
}