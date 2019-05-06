public class RiskEvaluationController {
    
    public Map<String,Map<String,Model_Sub_Category_Definition__c>> finalMap{set;get;} // map with categories and map of wrapper
    public Map<String,Model_Sub_Category_Definition__c> subcat1Map {set;get;}
    public Map<String, Model_Category_Definition__c> categoryMap{set;get;}
    public String subCategory{set;get;}
    public String categoryName{set;get;}
    public Map<Id,Model_Category_Definition__c> catMap;
    public Map<String,ModelCategoryWrapper> modelMap{set;get;}
    public Map<String,String> modelCategoryMap{set;get;}
    public String catId{set;get;}
    public String subCatHistoryListId{set;get;}
    public String catHistoryListId{set;get;}
    public String subCatHistoryCatName{set;get;}
    
    //SCORES
    public Score__c scoreValue{set;get;}  
    public Score__c resScoreValue{set;get;}
    
    
    public String subCatName{set;get;}
    public Decimal derivedAccountScore{set;get;}
    public Decimal residualDerivedAccountScore{set;get;}
    public String accId{set;get;}
    public Map<Id,Indicator_Value__c> mapIndicatorValue{set;get;}
    public Account objAcc{set;get;}
    public Model_Version__c modelVersion{set;get;}
    public Score__c objScoreRetrieve{set;get;}
    public Score__c resScoreRetrieve{set;get;}
    public List<Category_History__c> lstCatHistory{set;get;}
    public List<Sub_Category_History__c> lstSubCatHistory{set;get;}
    public Account acc{set;get;}
    public Map<String,String> mapListView{set;get;}
    public Map<String,String> mapIdName{set;get;}
    public Map<Integer,String> modelMapDisplayOrder{set;get;}
    
    public RiskEvaluationController(){
        derivedAccountScore =0;
        residualDerivedAccountScore=0;
        lstCatHistory = new List<Category_History__c>();
        lstSubCatHistory = new List<Sub_Category_History__c>();
        objScoreRetrieve= new Score__c();
        resScoreRetrieve= new Score__c();
        modelMap = new Map<String,ModelCategoryWrapper>();
        modelCategoryMap = new Map<String,String>();
        mapIndicatorValue = new Map<Id,Indicator_Value__c>();
        categoryMap = new Map<String, Model_Category_Definition__c>();
        String recId = ApexPages.currentPage().getParameters().get('Id');
        accId = recId;
        scoreValue = new Score__c();
        resScoreValue =new Score__c();
        objAcc = new Account();
        mapListView = new Map<String,String>();
        mapIdName = new Map<String,String>();
        modelMapDisplayOrder = new Map<Integer,String>();
        
        System.debug('------accId-----'+accId);
        if(recId == null || recId ==''){
            
        }
        else{
            try{
                Model_Version__c modelVersion = [select Id FROM Model_Version__c ORDER BY CreatedDate Desc LIMIT 1];
                System.debug('-----modelVersion------'+modelVersion);
                
                if(modelVersion.Id != null)
                    for(Model_Category_Definition__c  modelCategory :[select name , Weight__c , Category_Score__c , Display_order__c from Model_Category_Definition__c where Model_Version__c =: modelVersion.Id] ){
                        ModelCategoryWrapper mcw = new ModelCategoryWrapper();
                        mcw.CategoryName = modelCategory.Name;
                        mcw.modelCategory = modelCategory;
                        if(modelCategory.Weight__c == null){
                            mcw.modelCategory.Weight__c = 0;    
                        }
                        modelMap.put(modelCategory.Id,mcw );
                        modelMapDisplayOrder.put(Integer.valueOf(modelCategory.Display_order__c), modelCategory.Id);
                        modelCategoryMap.put(modelCategory.Name,modelCategory.Id);
                    }
                set<Id> subCatid = new set<Id>();
                for(Model_Sub_Category_Definition__c msc :[select id,name,Display_Order__c, Sub_Category_Score__c, Model_Category_Definition__c,Sub_Category_Weight__c from Model_Sub_Category_Definition__c where Model_Category_Definition__c IN :modelMap.keySet()]){
                    ModelCategoryWrapper mcw = modelMap.get(msc.Model_Category_Definition__c);
                    ModelCategoryWrapper.ModelSubCatWrapper subcatWrap = new ModelCategoryWrapper.ModelSubCatWrapper (msc.Id);
                    subCatid.add(msc.Id);
                    subcatWrap.subCatName = msc.Name;
                    subcatWrap.modelSubCat = msc;
                    if(msc.Sub_Category_Weight__c == null){
                        subcatWrap.modelSubCat.Sub_Category_Weight__c = 0;
                    }
                    System.debug('-------msc---------'+msc );
                    //mcw.subCatWrapperList.add(subcatWrap);    --- Add a set here to store all the sub cat definition ID
                    mcw.subCatWrapperMap.put(msc.Name,subcatWrap);
                }
                
                // Use the above set of subCat IDs to get corresponding records of Indicator definition
                for(Model_Indicator_Definitions__c mid :[select name,Display_Order__c,Indicator_Weight__c,
                                                         Model_Sub_Category_Definition__r.Name,Model_Sub_Category_Definition__r.Model_Category_Definition__c,
                                                         Model_Sub_Category_Definition__c,Score_Labels__c,Version__c,Score_Guidance_Mid__c,Score_Guidance_High__c,Score_Guidance_Low__c
                                                         from Model_Indicator_Definitions__c WHERE Model_Sub_Category_Definition__c=:subCatid])
                {  
                    ModelCategoryWrapper mcw = modelMap.get(mid.Model_Sub_Category_Definition__r.Model_Category_Definition__c);
                    ModelCategoryWrapper.ModelSubCatWrapper scw= mcw.subCatWrapperMap.get(mid.Model_Sub_Category_Definition__r.Name);
                    ModelCategoryWrapper.ModelIndicatorWrapper miw = new ModelCategoryWrapper.ModelIndicatorWrapper();
                    miw.labelName = mid.Score_Labels__c;
                    miw.modelIndicator = mid;
                    scw.indicatorWrapperMap.put(miw.labelName,miw);
                    System.debug('----mid----'+mid);
                }
                listViewId();
                
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getCause() +'  '+e.getMessage()));
            }
        }
        try{
            acc = [Select Id, Name, Model_Version_Lookup__c, Model_Version__c from Account where Id =:recId ];    
            
            List<Model_Version__c> modelVersion1 = [select Id, Name, Changed_By__c, Changed_Date__c FROM Model_Version__c where Id =: acc.Model_Version_Lookup__c];
            if(modelVersion1.size()>0)
                modelVersion = modelVersion1[0];
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getCause() +'  '+e.getMessage()));
        }
        // Call to retrieve values if Existed
        try{
            retrieval();    
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error In Fetching The Record'));
        }
    }
    
    public void calculate(){
        derivedAccountScore =0;
        residualDerivedAccountScore =0;
        Decimal totalCategoryWeight = 0;
        for(ModelCategoryWrapper modelCat : modelMap.values()){
            Decimal score =0;
            Decimal resScore=0;
            Decimal totalWeight = 0;
            for(ModelCategoryWrapper.ModelSubCatWrapper msw :modelCat.subCatWrapperMap.values()){
                //This will calculate on sub cat level
                calculateSubCats(msw);
                
                //Category Level
                Decimal cls = (msw.modelSubCat.Sub_Category_Weight__c==null? 0: msw.modelSubCat.Sub_Category_Weight__c)*(msw.subCatHistory.Sub_Category_Score__c==null?0:msw.subCatHistory.Sub_Category_Score__c);
                Decimal rcls = (msw.modelSubCat.Sub_Category_Weight__c==null? 0: msw.modelSubCat.Sub_Category_Weight__c)*(msw.ressubCatHistory.Sub_Category_Score__c==null?0:msw.resSubCatHistory.Sub_Category_Score__c);
                score = score+cls;
                resScore =resScore+ rcls;
                System.debug('msw.modelSubCat.Sub_Category_Weight__c ...'+msw.modelSubCat.Sub_Category_Weight__c);
                totalWeight= totalWeight + (msw.modelSubCat.Sub_Category_Weight__c==NULL?0:msw.modelSubCat.Sub_Category_Weight__c);
            }
            System.debug('Scores - '+score+' ResScore - '+resScore);
            System.debug('totalWeight - '+totalWeight);
            modelCat.catHistory.Category_Score__c = (totalWeight==0?0:score/totalWeight);
            modelCat.resCatHistory.Category_Score__c = (totalWeight==0?0:resScore/totalWeight);
            
            //Account Level Score Calculation
            residualDerivedAccountScore += (modelCat.resCatHistory.Category_Score__c*modelCat.modelCategory.Weight__c);
            derivedAccountScore += (modelCat.catHistory.Category_Score__c*modelCat.modelCategory.Weight__c); 
            totalCategoryWeight += modelCat.modelCategory.Weight__c;        
        }
        if(totalCategoryWeight >0){
            residualDerivedAccountScore = residualDerivedAccountScore/totalCategoryWeight;   
            derivedAccountScore = derivedAccountScore/totalCategoryWeight;
        }
        
        
    }
    
    public void calculateSubCats(ModelCategoryWrapper.ModelSubCatWrapper msw){
        
        Decimal score=0;
        Decimal indicatorWeight=0;
        Decimal resScore=0;
        Decimal resIndicatorWeight=0;
        
        for(ModelCategoryWrapper.ModelIndicatorWrapper mip : msw.indicatorWrapperMap.values()) {
            
            Decimal vw= (mip.indicatorValue.Value__c==null? 0:mip.indicatorValue.Value__c) * (mip.modelIndicator.Indicator_Weight__c==null? 0:mip.modelIndicator.Indicator_Weight__c);
            Decimal resvw= (mip.indicatorValue.Residual_Indicator_Value__c==null? 0:mip.indicatorValue.Residual_Indicator_Value__c) * (mip.modelIndicator.Indicator_Weight__c==null? 0:mip.modelIndicator.Indicator_Weight__c);
            score = score + vw;
            resScore +=resvw;
            indicatorWeight = indicatorWeight + (mip.modelIndicator.Indicator_Weight__c==NULL?0:mip.modelIndicator.Indicator_Weight__c);
        }
        System.debug('Scores - '+score+' ResScore - '+resScore);
                    
        if(indicatorWeight!=0){
            msw.subCatHistory.Sub_Category_Score__c = score/indicatorWeight;
            if (msw.subCatHistory.Sub_Category_Score__c < 4) {
                msw.subCatHistory.Sub_Category_Score__c = msw.subCatHistory.Sub_Category_Score__c * 25;
            }
            msw.resSubCatHistory.Sub_Category_Score__c = resScore/indicatorWeight;
            if (msw.resSubCatHistory.Sub_Category_Score__c < 4) {
                msw.resSubCatHistory.Sub_Category_Score__c = msw.resSubCatHistory.Sub_Category_Score__c * 25;
            }
        }
    }
    
    public void calculateForCat(){
        ModelCategoryWrapper modelCat = modelMap.get(CatId);
        Decimal catLevelScore = 0;
        Decimal resCatLevelScore = 0;
        Decimal subCatWeight = 0;
        for(ModelCategoryWrapper.ModelSubCatWrapper mcw :  modelCat.subCatWrapperMap.values()){
            Decimal cls = (mcw.modelSubCat.Sub_Category_Weight__c==null? 0: mcw.modelSubCat.Sub_Category_Weight__c)*(mcw.derivedSubCatScore==null? 0: mcw.derivedSubCatScore);
            Decimal rcls = (mcw.modelSubCat.Sub_Category_Weight__c==null? 0: mcw.modelSubCat.Sub_Category_Weight__c)*(mcw.residualSubCatScore==null? 0: mcw.residualSubCatScore);
            catLevelScore = catLevelScore + cls;
            resCatLevelScore += rcls;
            subCatWeight = subCatWeight + mcw.modelSubCat.Sub_Category_Weight__c;
        }
        if(subCatWeight!= 0){
            modelCat.derivedCatScore = catLevelScore/subCatWeight;
            modelCat.residualCatScore = resCatLevelScore/subCatWeight;
        }
        
    }
    
    
    public void calculateForAccount(){
        Decimal calculateForAccount = 0;
        Decimal resCalculateForAccount = 0;
        Decimal categoryWeight = 0;
        for(ModelCategoryWrapper mCat : modelMap.values()){
            Decimal als = (mCat.modelCategory.Weight__c==null? 0:mCat.modelCategory.Weight__c )*(mCat.derivedCatScore == null? 0: mCat.derivedCatScore);
            Decimal rals = (mCat.modelCategory.Weight__c==null? 0:mCat.modelCategory.Weight__c )*(mCat.residualCatScore == null? 0: mCat.residualCatScore);
            calculateForAccount = calculateForAccount + als;
            resCalculateForAccount = resCalculateForAccount + rals;
            categoryWeight = categoryWeight + mCat.modelCategory.Weight__c;
        }
        if(categoryWeight!=0){
            derivedAccountScore = calculateForAccount/categoryWeight;
            residualDerivedAccountScore = resCalculateForAccount/categoryWeight;
        }
    }
    
    public void save(){
        calculate();
        
        
        List<Score__c> scores = new List<Score__c>();
        
        scoreValue.Account__c = accId;
        ScoreValue.Name = 'Inherited Score';
        ScoreValue.Most_Recent_Score__c = derivedAccountScore ;
        //upsert scoreValue;
        
        resScoreValue.Account__c = accId;
        resScoreValue.Name = 'Residual Score';
        resScoreValue.Most_Recent_Score__c = residualDerivedAccountScore;
        //upsert resScoreValue;
        
        
        scoreValue.Active_From__c = System.Today();
        resScoreValue.Active_From__c = System.Today();
        scores.add(scoreValue);
        scores.add(resScoreValue);
        
        
        upsert scores;
        
        
        for(ModelCategoryWrapper modelCat : modelMap.values()){
            
            modelCat.save(scoreValue.id,resScoreValue.Id);
            modelCat.isSaveCat = true;   
        }
    }
    
    
    
    
    
    public void saveScore(){
        calculateForAccount();
        List<Score__c> scoreList = new List<Score__c>();
        if(scoreValue.Account__c != null){
            scoreValue.Most_Recent_Score__c = derivedAccountScore;
            scoreValue.Version__c = acc.Model_Version_Lookup__c;
            scoreValue.Active_From__c = System.Now();
            scoreList.add(scoreValue);
            if(objScoreRetrieve.Active_To__c == null && objScoreRetrieve.Id != null){
                objScoreRetrieve.Active_To__c = System.Now();
                update objScoreRetrieve;
                scoreList.add(objScoreRetrieve);
            }
        }
        
        if(resScoreValue.Account__c != null){
            resScoreValue.Most_Recent_Score__c = residualDerivedAccountScore;
            resScoreValue.Version__c = acc.Model_Version_Lookup__c;
            resScoreValue.Active_From__c = System.Now();
            scoreList.add(resScoreValue);
        }
        update scoreList;
    }
    
  
    public void saveCatScore(){
        calculateForCat();
        ModelCategoryWrapper modelCat = modelMap.get(catId);
        System.debug('scoreValue.Id...'+scoreValue.Id);
        System.debug('resScoreValue.Id...'+resScoreValue.Id);
        if(!modelCat.isSaveCat){
            Category_History__c objCat = new Category_History__c();
            objCat.Date_Computed__c = System.today();
            objCat.Category_Score__c = modelCat.derivedCatScore;
            objCat.Model_Category_DefinitionLookup__c = catId;
            objCat.Score__c = scoreValue.Id;
            
            insert objCat;
            
            Category_History__c objCatRes = new Category_History__c();
            objCatRes.Date_Computed__c = System.today();
            objCatRes.Category_Score__c = modelCat.residualCatScore;
            objCatRes.Model_Category_DefinitionLookup__c = catId;
            objCatRes.Score__c = resScoreValue.Id;
            
            insert objCatRes;
            modelCat.catHistory = objCat;
            modelCat.resCatHistory = objCatRes;
            modelCat.isSaveCat=true;
        }
        else{
            Category_History__c objCat = modelCat.catHistory;
            objCat.Date_Computed__c = System.today();
            objCat.Category_Score__c = modelCat.derivedCatScore;
            objCat.Model_Category_DefinitionLookup__c = catId;
            //objCat.Score__c = scoreValue.Id;
            update objCat;
            
            Category_History__c objCatRes = modelCat.catHistory;
            objCatRes.Date_Computed__c = System.today();
            objCatRes.Category_Score__c = modelCat.residualCatScore;
            objCatRes.Model_Category_DefinitionLookup__c = catId;
            //objCatRes.Score__c = resScoreValue.Id;
            update objCatRes;
        }
    }
    
    public void retrieval(){
        List<Score__c> scores= [select Id, Account__c, Active_From__c, Active_To__c, Most_Recent_Score__c, Version__c FROM Score__c WHERE Account__c =: accId AND name !='Residual Score' ORDER BY createdDate  DESC LIMIT 1];
        if(scores.size()>0){
            objScoreRetrieve = scores[0];
            
            for(Indicator_Value__c objIndicatorRetrieve:[select Id, Model_Indicator_Definition__c, Model_Indicator_Definition__r.Name,Model_Indicator_Definition__r.Score_Labels__c,
                                                         Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Model_Category_Definition__c,
                                                         Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Model_Category_Definition__r.Weight__c,
                                                         Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Model_Category_Definition__r.Name,
                                                         Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Model_Category_Definition__r.Category_Score__c,
                                                         Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Name,Model_Indicator_Definition__r.Model_Sub_Category_Definition__c,  
                                                         Model_Indicator_Definition__r.Indicator_Weight__c,Residual_Indicator_Value__c,                
                                                         Note__c, Name, Score__c, Value__c FROM Indicator_Value__c 
                                                         WHERE Score__c =: objScoreRetrieve.Id]){
                                                             
                                                             ModelCategoryWrapper mcw =ModelMap.get(objIndicatorRetrieve.Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Model_Category_Definition__c);
                                                             ModelCategoryWrapper.ModelSubCatWrapper scw = mcw.subCatWrapperMap.get(objIndicatorRetrieve.Model_Indicator_Definition__r.Model_Sub_Category_Definition__r.Name);               
                                                             ModelCategoryWrapper.ModelIndicatorWrapper  miw = scw.indicatorWrapperMap.get(objIndicatorRetrieve.Model_Indicator_Definition__r.Score_Labels__c);
                                                             
                                                             miw.indicatorValue.Value__c = objIndicatorRetrieve.Value__c;
                                                             miw.indicatorValue.Score__c = objIndicatorRetrieve.Score__c;
                                                             miw.indicatorValue.Note__c = objIndicatorRetrieve.Note__c;
                                                             miw.indicatorValue = objIndicatorRetrieve;
                                                         }
            getCategoryHistories();
            for(Model_Category_Definition__c mc : [select id from Model_Category_Definition__c ]){
                catId = mc.Id;
                calculate();    
            }
        }
    }
    
    
    public void getCategoryHistories(){
        for(Category_History__c catHistory :[select Model_Category_DefinitionLookup__c,Score__c,Direction_Of_Risk__c from Category_History__c where Score__c = :objScoreRetrieve.Id]){
            
            modelMap.get(catHistory.Model_Category_DefinitionLookup__c).catHistory.Direction_Of_Risk__c = catHistory.Direction_Of_Risk__c;
        }
    }
    
    public void listViewId(){
        
        List<ListView> catListViews= [Select id, SobjectType, DeveloperName from ListView where SobjectType='Category_History__c' and DeveloperName = 'All'];
        if(catListViews.size()>0){
            catHistoryListId = catListViews[0].id;
        }
        for(ListView v :[Select id,SobjectType,DeveloperName from ListView where SobjectType='Sub_Category_History__c' and DeveloperName != 'All']){
            mapListView.put(v.DeveloperName,v.Id);    
        }
        subCatHistoryListId = mapListView.get(modelMap.get(modelMapDisplayOrder.get(1)).CategoryName).subString(0,15);
    }
    
    
    public void changeSubCat(){
        if(mapListView.containsKey(subCatHistoryCatName)){
            subCatHistoryListId  = mapListView.get(subCatHistoryCatName).subString(0,15);
        }
        System.debug('subCatHistoryListId....'+subCatHistoryListId);
    }
}