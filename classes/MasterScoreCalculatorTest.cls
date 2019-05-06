@isTest
public class MasterScoreCalculatorTest {
	

	//public String catId;
   // public String subCatName;
    
	@testSetup
	static void testRiskEvaluationSetup(){
		
        Model_Version__c objmodelVersion = new Model_Version__c();
			objmodelVersion.Name = 'Test model Version';
			insert objModelversion;
            System.debug('>>>>>>objModelversion'+objModelversion);
        
		Account objAccount = new Account();
			objAccount.Name = 'Test Account';
            objAccount.Most_Recent_Risk_Score__c = 1.2;
            objAccount.Model_Version_Lookup__c = objmodelVersion.Id;
			insert objAccount;
            System.debug('>>>>>>objAccount'+objAccount);
        
        Score__c objScore = new Score__c();
			objScore.Name = 'Inherited Score';
			objScore.Account__c = objAccount.Id;
			objScore.Active_From__c = datetime.newInstance(2018, 12, 19, 12, 30, 0);
			objScore.Active_To__c = datetime.newInstance(2018, 12, 15, 20, 30, 0);
			objScore.Most_Recent_Score__c = 35;
			objScore.Version__c = objAccount.Model_Version_Lookup__c;
			insert objScore;
            System.debug('>>>>>>objScore'+objScore);
				
        
        Score__c objScoreRes = new Score__c();
			objScoreRes.Name = 'Residual Score';
			objScoreRes.Account__c = objAccount.Id;
			objScoreRes.Active_From__c = datetime.newInstance(2018, 12, 19, 12, 30, 0);
			objScoreRes.Active_To__c = datetime.newInstance(2018, 12, 15, 20, 30, 0);
			objScoreRes.Most_Recent_Score__c = 35;
			objScoreRes.Version__c = objAccount.Model_Version_Lookup__c;
			insert objScoreRes;
        
        
		Model_Category_Definition__c objModelCategory = new Model_Category_Definition__c();
			objModelCategory.Name = 'Regulatory';
			objModelCategory.Model_Version__c = objmodelVersion.Id;
			objModelCategory.Weight__c = 30;
			objModelCategory.Category_Score__c = 112;
            objModelCategory.Display_Order__c = 1;
			insert objModelCategory;
            System.debug('>>>>>>objModelCategory'+objModelCategory);
            //String catId = objModelCategory.Id;
		
		Model_Sub_Category_Definition__c objModelSubCat = new Model_Sub_Category_Definition__c();
			objModelSubCat.Name = 'Test Model SubCategory';
			objModelSubCat.Model_Category_Definition__c = objModelCategory.Id;
			objModelSubCat.Sub_Category_Score__c = 211;
			objModelSubCat.Sub_Category_Weight__c = 20;
        	objModelSubCat.Display_Order__c = 2;
			insert objModelSubCat;
            System.debug('>>>>>>objModelSubCat'+objModelSubCat);
            //String subCatName = objModelSubCat.Name;
			
		Model_Indicator_Definitions__c objModelIndDef = new Model_Indicator_Definitions__c();
			objModelIndDef.Name = 'Test Model Indicator';
			objModelIndDef.Indicator_Weight__c = 20;
			objModelIndDef.Model_Sub_Category_Definition__c = objModelSubCat.Id;
			objModelIndDef.Score_Labels__c = 'Test Score Label';
			objModelIndDef.Display_Order__c = 1;
			insert objModelIndDef;
            System.debug('>>>>>>objModelIndDef'+objModelIndDef);
		
		
		
		Category_History__c objCatHistory = new Category_History__c();
			objCatHistory.Name = 'Test Category History';
			objCatHistory.Category_Score__c = 45;
			objCatHistory.Date_Computed__c = System.today();
			objCatHistory.Model_Category_DefinitionLookup__c = objModelCategory.Id;
			objCatHistory.Score__c = objScore.Id;
			insert objCatHistory;
            System.debug('>>>>>>objCatHistory'+objCatHistory);
		
		Sub_Category_History__c objSubCatHistory = new Sub_Category_History__c();
			objSubCatHistory.Name = 'Test Sub Catgeory History';
			objSubCatHistory.Date_Computed__c = Date.newInstance(2018, 12, 19);
			objSubCatHistory.Model_Category_Definition__c = objModelCategory.Id;
			//objSubCatHistory.Model_Category_Definition_Formula__c
			objSubCatHistory.Model_Sub_Category_DefinitionLookup__c = objModelSubCat.Id;
			objSubCatHistory.Score__c = objScore.Id;
			objSubCatHistory.Sub_Category_Score__c = 30;
			insert objSubCatHistory;
            System.debug('>>>>>>objSubCatHistory'+objSubCatHistory);
		
		Indicator_Value__c objIndicatorValue = new Indicator_Value__c();
			objIndicatorValue.Name = 'Test Indicator Value';
			objIndicatorValue.Note__c = 'Test Indicator Note';
			objIndicatorValue.Model_Indicator_Definition__c = objModelIndDef.Id;
			objIndicatorValue.Score__c = objScore.Id;
			objIndicatorValue.Value__c = 90;
            insert objIndicatorValue;
        
           	objIndicatorValue.Name = 'Test Indicator';
             objIndicatorValue.Value__c = 20;


            update objIndicatorValue;
	}
	
	@isTest
	static void testEvaluation(){
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        objAccount.Is_Master_Account__c= true ;
        insert objAccount;
        
        Account accs = [Select Program_ID__c, id ,(select Id FROM Scores__r where name ='Residual Score' ORDER BY createdDate  DESC LIMIT 1) from Account where  Is_Master_Account__c = false];
        System.debug([select Id,Account__c FROM Score__c]);
        
		Test.startTest();
        	ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        	MasterScoreCalculator  mc = new MasterScoreCalculator();
        	mc.doStart();
        Test.stopTest();
        
    }
    
    
    

}