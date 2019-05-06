/*
* @Purpose: To generate the Values for ModelCategoryMap
*/ 
public class RiskCategoryPageNewController { 
   
    /*
     * @Purpose: To generate the Values for ModelCategoryMap
     */ 
    @RemoteAction
    public static List<ModelCategoryDetailWrapper> composeMapValues(String accountId, String scoreType){
      
        if(String.isNotBlank(accountId)){
           
            List<Model_Sub_Category_Definition__c> categoryAndSubCategoryNameList;
            // Fetch the Model Category and Sub Category Names
            try{
                categoryAndSubCategoryNameList = [SELECT Id, Name, Model_Category_Definition__r.Name 
                                                  FROM Model_Sub_Category_Definition__c
                                                  ORDER BY Model_Category_Definition__r.Name]; 
                
            }catch(Exception ex){
              System.debug('Exception occure while fetching Model Sub Catgory Definition data is::::'+ex.getMessage());    
            }
            
            
            // Create the WrapperList containg Wrapper Object for each pair of Category and its Sub Category
            List<ModelCategoryDetailWrapper> modelCategoryDetailWrapperList = new List<ModelCategoryDetailWrapper>();
            
            if(categoryAndSubCategoryNameList != null && !categoryAndSubCategoryNameList.isEmpty()){
                
                for(Model_Sub_Category_Definition__c categoryAndSubCategoryData :categoryAndSubCategoryNameList){
                    
                    modelCategoryDetailWrapperList.add(new ModelCategoryDetailWrapper(categoryAndSubCategoryData.Model_Category_Definition__r.Name,
                                                                                      categoryAndSubCategoryData.Name));
                }
                
                
                List<Sub_Category_History__c> categoryAndSubCategoryHistoryList;
                // Fetch the score for each of the Sub Category
                try{
                    categoryAndSubCategoryHistoryList = Database.query('SELECT Id,Model_Sub_Category_DefinitionLookup__r.Name,Sub_Category_Score__c,'+
                                                                'Model_Category_Definition_Formula__c, LastModifiedDate '+
                                                         'FROM Sub_Category_History__c '+
                                                         'WHERE Score__r.Account__c = :accountId AND Score__r.Name=:scoreType');    
                }catch(Exception ex){
                  System.debug('Exception occured while fetching Sub Category History is::::'+ex.getMessage());    
                }
                
                if(categoryAndSubCategoryHistoryList != null && !categoryAndSubCategoryHistoryList.isEmpty()){
                    // Call the method to assign score value to each pair of Category and Sub Category
                    createModelCategoryWrapper(categoryAndSubCategoryHistoryList, modelCategoryDetailWrapperList);      
                }
                return modelCategoryDetailWrapperList;
            }else{
                return null;
            }    
        }
        return null;
    }
    
    /*
     * @Purpose: Create ModelCategoryWrapper Data for Ctegory and Sub Category Pair
     */ 
    public static void createModelCategoryWrapper(List<Sub_Category_History__c> categoryAndSubCategoryHistoryList,
                                                  List<ModelCategoryDetailWrapper> modelCategoryDetailWrapperList){
                                                                                  
        if(categoryAndSubCategoryHistoryList != null && !categoryAndSubCategoryHistoryList.isEmpty() && 
           modelCategoryDetailWrapperList != null && !modelCategoryDetailWrapperList.isEmpty()){
            
            String tempScore;
            for(ModelCategoryDetailWrapper modelCategoryDetailWrapperObj : modelCategoryDetailWrapperList){
                
                for(Sub_Category_History__c categoryAndSubCategoryHistoryObj :categoryAndSubCategoryHistoryList){
                 
                    // if the Category and Sub Category of Wrpper Object is Match with Categeory and Sub Category on Sub_Category_History__c Object
                    if(categoryAndSubCategoryHistoryObj.Model_Category_Definition_Formula__c == modelCategoryDetailWrapperObj.category_label &&
                       categoryAndSubCategoryHistoryObj.Model_Sub_Category_DefinitionLookup__r.Name == modelCategoryDetailWrapperObj.question_label){
                          
                          tempScore = categoryAndSubCategoryHistoryObj.Sub_Category_Score__c != null ? String.valueOf(categoryAndSubCategoryHistoryObj.Sub_Category_Score__c) : '0';
                          // if this pair matches first time then Just store the value as it is
                          if(!modelCategoryDetailWrapperObj.isUpdated){
                            
                              modelCategoryDetailWrapperObj.value = tempScore;
                              modelCategoryDetailWrapperObj.isUpdated = true;  
                              modelCategoryDetailWrapperObj.LastModifiedDateVal = categoryAndSubCategoryHistoryObj.LastModifiedDate;
                          }else{
                               
                             // if there are two or more matches for category and sub category of Wrapper and Sub_Category_History__c object get the latest updated value by using last modified datetime
                             if(modelCategoryDetailWrapperObj.LastModifiedDateVal < categoryAndSubCategoryHistoryObj.LastModifiedDate){
                                 
                                 modelCategoryDetailWrapperObj.value = tempScore;
                                 modelCategoryDetailWrapperObj.value = String.valueOf(categoryAndSubCategoryHistoryObj.Sub_Category_Score__c);
                                 modelCategoryDetailWrapperObj.LastModifiedDateVal = categoryAndSubCategoryHistoryObj.LastModifiedDate;
                             }
                         }  
                  }    
                }
            }     
        } 
    }
    
    /*
     * @Purpose: Create Score Map for each of the Category and its value
     */
    @AuraEnabled
    public static  Map<String, Decimal> createEachCategoryScoreMap(String accountId, String scoreType){
        
        if(String.isNotBlank(accountId)){
            
            
            Map<String, Decimal> categoryNameToValueMap = new Map<String, Decimal>();            
            Score__c overallRiskScore;
            
            // to get Overall Score Risk fetch the record of Score which is latest modified
            try{
                overallRiskScore = [SELECT Id, Most_Recent_Score__c
                                    FROM Score__c 
                                    WHERE Account__c =: accountId 
                                    AND Active_to__c = NULL AND Name= :scoreType
                                    ORDER BY LastModifiedDate DESC 
                                    LIMIT 1];    
            }catch(Exception ex){
              System.debug('Exception occures while fetching Score Data is:::::'+ex.getMessage());    
            }
            
            if(overallRiskScore != null){
                if(overallRiskScore.Most_Recent_Score__c != null){
                  categoryNameToValueMap.put('Overall Risk Score',  overallRiskScore.Most_Recent_Score__c.setScale(2));    
                }else{
                    // if Most_Recent_Score__c is == NULL then put 0 for it
                  categoryNameToValueMap.put('Overall Risk Score',  0);    
                }
            }else{
              categoryNameToValueMap.put('Overall Risk Score',  0);    
            }
            
            List<Category_History__c> categoryScoreList; 
            // fetch the other sub category scores from Category History Object
            try{
                categoryScoreList = [SELECT Category_Score__c, Model_Category_DefinitionLookup__r.Name, LastModifiedDate 
                                     FROM Category_History__c 
                                     WHERE Score__r.Account__c =: accountId AND Score__r.Name= :scoreType];     
            }catch(Exception ex){
              System.debug('Exception occured while fetching Category History Data is:::::'+ex.getMessage());    
            }
            System.debug('categoryScoreList:::'+categoryScoreList);
            
            Map<String, Category_History__c>  subCategoryNameToValueMap = new Map<String, Category_History__c>();
            if(categoryScoreList != null && !categoryScoreList.isEmpty()){
                for(Category_History__c categoryScoreListObj :categoryScoreList){                   
                   
                    if(subCategoryNameToValueMap.containsKey(categoryScoreListObj.Model_Category_DefinitionLookup__r.Name)){ 
                        
                        Category_History__c categoryHistoryObj = (Category_History__c)subCategoryNameToValueMap.get(categoryScoreListObj.Model_Category_DefinitionLookup__r.Name);
                        // if sub category occures two or more time then stored the value from latest modified category record
                        if(categoryHistoryObj.LastModifiedDate < categoryScoreListObj.LastModifiedDate){
                            subCategoryNameToValueMap.put(categoryScoreListObj.Model_Category_DefinitionLookup__r.Name, categoryScoreListObj);    
                        }
                    }else{
                        // if sub category occures first time then store its value a it is
                        subCategoryNameToValueMap.put(categoryScoreListObj.Model_Category_DefinitionLookup__r.Name, categoryScoreListObj);    
                    }    
                }
            }
            System.debug('subCategoryNameToValueMap::::'+subCategoryNameToValueMap);
            
            List<Model_Category_Definition__c> subCategoryNameList;
            // fetch all the sub category in order to create final map
            try{
                subCategoryNameList = [SELECT Id, Name 
                                       FROM Model_Category_Definition__c];    
            }catch(Exception ex){
              System.debug('Exception occured while fetching Model Category Definition is:::::'+ex.getMessage());    
            }
            if(subCategoryNameList != null && !subCategoryNameList.isEmpty()){
                
                for(Model_Category_Definition__c  modelCategoryDefinitionObj : subCategoryNameList){
                    
                    Decimal tempVal; 
                    
                    if(subCategoryNameToValueMap.containsKey(modelCategoryDefinitionObj.Name)){
                        tempVal = (subCategoryNameToValueMap.get(modelCategoryDefinitionObj.Name).Category_Score__c != null ? (subCategoryNameToValueMap.get(modelCategoryDefinitionObj.Name).Category_Score__c).setScale(2) : 0);
                        
                        categoryNameToValueMap.put(modelCategoryDefinitionObj.Name,tempVal); 
                    }else{
                        categoryNameToValueMap.put(modelCategoryDefinitionObj.Name, 0);      
                    }                                                          
                }
                System.debug('categoryNameToValueMap:::::'+categoryNameToValueMap);
                return categoryNameToValueMap;     
            }
        }
        
        return null;
    }

  /*
     * @Purpose: Wrapper to hold Model Category and SubCategory Details
     */     
    public class ModelCategoryDetailWrapper{
        string category_label;
        string question_label;
        String value;
        DateTime LastModifiedDateVal;
        Boolean isUpdated;
        
        public ModelCategoryDetailWrapper(String mainCategoryData, String subCategoryData){
            
            this.category_label = mainCategoryData;
            this.question_label = subCategoryData;
            this.value = '0';
            this.isUpdated = false;
        }
    }
    
    @RemoteAction
    public static String getAccountFromUserId(String passedAccountId){
        
        if (String.isNotBlank(passedAccountId)) { //  Call from GUI with passed ID
        	return passedAccountId;
        } else {                      //  Call from VF page
        	String accountId;
        	List<User> theUser = [SELECT Contact.AccountId
        	    FROM User
        	    WHERE ID = :UserInfo.getUserId() ];
            If (theUser.size() != 0) {
                accountId = theUser[0].Contact.AccountId;
                return accountId;
            } else {
            	return null;
            }	
        } 
        
    }
    
    
    
}