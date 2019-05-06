/*
 * @Purpose : Test class for RiskCategoryPageNewController
 */
@isTest
public class RiskCategoryPageNewControllerTest {

   /*
    * @Purpose : Create data required for testing
    */
    @TestSetup
    public Static void createTestData(){        
  
        // Create Account
        Account accountObj = new Account(Name = 'Test Account');
        insert accountObj;
        
        // Create Model Category Definition
        Model_Category_Definition__c modelCategoryDefinitionObj = new Model_Category_Definition__c(Name = 'Test Model Category Definition');
        insert modelCategoryDefinitionObj;
        
        // Create Model Sub Category Definition
        Model_Sub_Category_Definition__c modelSubCategoryDefinitionObj = new Model_Sub_Category_Definition__c(Name = 'Test Model Sub Category Definition',
                                                                                                             Model_Category_Definition__c = modelCategoryDefinitionObj.id);
        insert modelSubCategoryDefinitionObj;
        
        // Create Score
        Score__c scoreObj = new Score__c(Name = 'Inherited Score',
                                         Account__c = accountObj.id,
                                         Most_Recent_Score__c = 40);
        insert scoreObj;
        
        // Create Sub Category History
        List<Sub_Category_History__c> subCategoryHistoryObjList = new List<Sub_Category_History__c>();
        for(integer index = 0; index < 4; index ++){
            Sub_Category_History__c subCategoryHistoryObj = new Sub_Category_History__c(Name = 'Test Sub Category History'+index,
                                                                                        Score__c = scoreObj.id,
                                                                                        Sub_Category_Score__c = 20,
                                                                                        Model_Category_Definition__c = modelCategoryDefinitionObj.id,
                                                                                        Model_Sub_Category_DefinitionLookup__c = modelSubCategoryDefinitionObj.id); 
            subCategoryHistoryObjList.add(subCategoryHistoryObj);
        }
        
        insert subCategoryHistoryObjList;
        
        // Create Category History
        Category_History__c categoryHistoryObj = new Category_History__c(Name = 'Test Category History',
                                                                         Score__c = scoreObj.id,
                                                                         Model_Category_DefinitionLookup__c = modelCategoryDefinitionObj.id);
        insert categoryHistoryObj;
        
    }    
    
   /*
    * @Purpose : To Test functionality(Positive Testing)
    */
    @isTest
    public static void functionalityPositiveTest(){      
               
        Test.startTest();
          Account accountObj = [SELECT id FROM Account LIMIT 1];
          
          List<RiskCategoryPageNewController.ModelCategoryDetailWrapper> modelCategoryDetailWrapperList = RiskCategoryPageNewController.composeMapValues(accountObj.id,'Inherited Score');
            System.assertNotEquals(modelCategoryDetailWrapperList.size(), 0);
        
            Map<String, Decimal> subCategoryToScoreMap = RiskCategoryPageNewController.createEachCategoryScoreMap(accountObj.id,'Inherited Score');
          System.assertNotEquals(subCategoryToScoreMap.keySet().size(), 0);        
        Test.stopTest();
    }
    
   /*
    * @Purpose : To Test functionality(Negative Testing)
    */
    @isTest
    public static void functionalityNegativeTest(){      
               
        Test.startTest();
          
            Account accountObj = [SELECT id FROM Account LIMIT 1];
            List<RiskCategoryPageNewController.ModelCategoryDetailWrapper> modelCategoryDetailWrapperList = RiskCategoryPageNewController.composeMapValues('','Inherited Score');
            System.assertEquals(modelCategoryDetailWrapperList, NULL);
        
            Map<String, Decimal> subCategoryToScoreMap = RiskCategoryPageNewController.createEachCategoryScoreMap('','Inherited Score');
          System.assertEquals(subCategoryToScoreMap, NULL);     
        
          Score__c scoreObj = [SELECT id,Most_Recent_Score__c
                                 FROM Score__c
                                 LIMIT 1];
            scoreObj.Most_Recent_Score__c = NULL;
          
          update scoreObj;
          
          RiskCategoryPageNewController.createEachCategoryScoreMap(accountObj.id,'Inherited Score');
        Test.stopTest();
    }
    
    @isTest
    public static void testGetUsersAccount(){      
    	
    	Account acct = new Account(Name='Test');
    	insert acct;
		Id acctId = acct.Id;
		
		Contact cont = new Contact(LastName='Test', AccountId=acct.Id);
		insert cont;
		Id contId = cont.Id;
		    	
		User usr = new User(
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community Limited'].Id,
	    	LastName = 'last',
	    	Email = 'testuser@damaone.com',
	    	Username = 'testuser@damaone.com',
	    	CompanyName = 'TEST',
	    	Title = 'title',
	    	Alias = 'alias',
	    	TimeZoneSidKey = 'America/Los_Angeles',
	    	EmailEncodingKey = 'UTF-8',
	    	LanguageLocaleKey = 'en_US',
	    	LocaleSidKey = 'en_US',
	    	ContactId = contId
		);
		insert usr;
		
		String s1 = RiskCategoryPageNewController.getAccountFromUserId(acctId);
    	
    	System.runAs(usr) {
    		String s2 = RiskCategoryPageNewController.getAccountFromUserId('');
    	}
    }
    
    
}