public class ModelCategoryWrapper {
    
    public String CategoryName{set;get;}
    public Model_Category_Definition__c modelCategory{set;get;}
    public Map<String,ModelSubCatWrapper> subCatWrapperMap{set;get;}
    public Category_History__c catHistory{set;get;}
    public Category_History__c resCatHistory{set;get;}
    public Decimal derivedCatScore{set;get;}
    public Decimal residualCatScore{set;get;}
    public Boolean isSaveCat;
    
    public ModelCategoryWrapper(){
        modelCategory = new Model_Category_Definition__c(weight__c=0);
        subCatWrapperMap = new Map<String,ModelSubCatWrapper>();
        catHistory = new Category_History__c(Category_Score__c=0);
        resCatHistory = new Category_History__c(Category_Score__c=0);
        derivedCatScore =0;
        residualCatScore =0;
        isSaveCat=false;
    }
    
    public void save(String scoreId, String resScoreId){
        
        System.debug('CatHistory score...'+CatHistory.Category_Score__c);
        System.debug('Res CatHistory score...'+resCatHistory.Category_Score__c);
        
        for(ModelCategoryWrapper.ModelSubCatWrapper msw :subCatWrapperMap.values()){
            
            //Save Sub Categories
            msw.save(scoreId,resScoreId,modelCategory.Id);
            
        }
        
        catHistory.Date_Computed__c = System.today();
        catHistory.Model_Category_DefinitionLookup__c = modelCategory.Id;
        catHistory.Score__c = scoreId;
        upsert catHistory;
        
        resCatHistory.Date_Computed__c = System.today();
        resCatHistory.Model_Category_DefinitionLookup__c = modelCategory.Id;
        resCatHistory.Score__c = resScoreId;
        upsert resCatHistory;
    }
    
    public class ModelSubCatWrapper{
        public String subCatName{set;get;}
        public Model_Sub_Category_Definition__c modelSubCat{set;get;}
        public Map<String,ModelIndicatorWrapper> indicatorWrapperMap{set;get;}
        public Sub_Category_History__c subCatHistory{set;get;}
        public Sub_Category_History__c resSubCatHistory{set;get;}
        public Decimal derivedSubCatScore{set;get;}
        public Decimal residualSubCatScore{set;get;}
        public Boolean isSaved;
        
        public ModelSubCatWrapper(String subCatId){
            modelSubCat = new Model_Sub_Category_Definition__c(Sub_Category_Weight__c=0);
            indicatorWrapperMap  = new Map<String,ModelIndicatorWrapper>();
            subCatHistory = new Sub_Category_History__c(Sub_Category_Score__c=0);
            resSubCatHistory = new Sub_Category_History__c(Sub_Category_Score__c=0);
            derivedSubCatScore = 0;
            residualSubCatScore =0;
            isSaved=false;
            modelSubCat.Sub_Category_Weight__c = 0;
        
        }
        
      public ModelSubCatWrapper(){
            subCatHistory = new Sub_Category_History__c();
        }
        
        public void save(String scoreId, String resScoreId, String catId){
            System.debug('subCatHistory score...'+subCatHistory.Sub_Category_Score__c);
            System.debug('RessubCatHistory score...'+RessubCatHistory.Sub_Category_Score__c);
            
            saveHistories(scoreId,resScoreId,catId);
            
            List<Indicator_Value__c> indicatorValues = new List<Indicator_Value__c>();
            for(ModelCategoryWrapper.ModelIndicatorWrapper miw : indicatorWrapperMap.values()){
                miw.save(scoreId,resScoreId,isSaved);
                indicatorValues.add(miw.indicatorValue);
            }
            if(!isSaved){
                insert indicatorValues;
            }
            else{
                update indicatorValues;
            }
            isSaved =true;
        }
        
        
        public void saveHistories(String scoreId, String resScoreId, String catId){
            subCatHistory.Date_Computed__c = System.Today();
            subCatHistory.Model_Sub_Category_DefinitionLookup__c = modelSubCat.id;
            
            subCatHistory.Score__c = scoreId;
            upsert subCatHistory;
            
            RessubCatHistory.Date_Computed__c = System.Today();
            RessubCatHistory.Model_Sub_Category_DefinitionLookup__c = modelSubCat.id;
            RessubCatHistory.Score__c = resScoreId;
            upsert RessubCatHistory;
        }
    }
    
    public class ModelIndicatorWrapper{
        public String labelName{set;get;}
        public Model_Indicator_Definitions__c modelIndicator{set;get;}
        public Indicator_Value__c indicatorValue{set;get;}
        
        
        public ModelIndicatorWrapper(){
            modelIndicator = new Model_Indicator_Definitions__c(Indicator_Weight__c=0);
            indicatorValue = new Indicator_Value__c();
        }
        
        public void save(String scoreId, String resScoreId,Boolean isSaved){
            indicatorValue.Score__c = scoreId;
            indicatorValue.Model_Indicator_Definition__c = modelIndicator.Id;
            indicatorValue.Name = modelIndicator.Score_Labels__c;
            if(!isSaved){
                indicatorValue.id=null;
            }
        }
    }
}