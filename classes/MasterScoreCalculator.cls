public class MasterScoreCalculator {
	public Score__c inheritedScore;
    public Score__c residualScore;
    public Account acc;
    public Integer count;
    public Boolean isMaster{set;get;}
    
    public MasterScoreCalculator(){
        String accId =ApexPages.currentPage().getParameters().get('Id');
        count =0;
        inheritedScore = new Score__c(Account__c = accId, Active_From__c = Date.today(), Name='Inherited Score');
        residualScore = new Score__c(Account__c = accId, Active_From__c = Date.today(), Name='Residual Score');
        acc = [select Program_ID__c,Id,Is_Master_Account__c from Account where id = :accId ];
        
        if(!acc.Is_Master_Account__c){
            isMaster = false;
        }
        else{
            isMaster = true;
        }
    }
    
    
    public PageReference doStart(){
        Set<String> scoreIds = new Set<String>();
        Set<String> resScoreIds = new Set<String>();
        for(Account accs : [Select Program_ID__c, id ,(select Id FROM Scores__r where name !='Residual Score' ORDER BY createdDate  DESC LIMIT 1) from Account where  Is_Master_Account__c = false AND Program_ID__c  = :acc.Program_ID__c]){
        	if(accs.Scores__r.size()>0)    
            	scoreIds.add(accs.Scores__r[0].Id);
            count++;
        }
        
        for(Account accs : [Select Program_ID__c, id ,(select Id FROM Scores__r where name ='Residual Score' ORDER BY createdDate  DESC LIMIT 1) from Account where  Is_Master_Account__c = false AND Program_ID__c  = :acc.Program_ID__c]){
        	if(accs.Scores__r.size()>0)    
            	resScoreIds.add(accs.Scores__r[0].Id);
        }
        if(isMaster){
            getIndicatorValues(scoreIds);
            subCatHistories(scoreIds,resScoreIds);
            CatHistories(scoreIds,resScoreIds);
            accountLevelScore(scoreIds,resScoreIds);
            return new PageReference('/'+acc.Id);    
        }
        else
        	return null;
    }
    
    
    public void getIndicatorValues(Set<String> scoreIds){
        Map<String, MasterScoreWrapper> wrapperMap = new Map<String, MasterScoreWrapper>(); // Maps Indicator definition label with wrapper class.
        insert inheritedScore;
        insert residualScore;
        for(Indicator_Value__c iv : [Select Model_Indicator_Definition__c,Model_Indicator_Definition__r.Score_Labels__c, Value__c, Residual_Indicator_Value__c from Indicator_Value__c where Score__c IN :scoreIds]){
            if(!wrapperMap.containsKey(iv.Model_Indicator_Definition__r.Score_Labels__c)){
                wrapperMap.put(iv.Model_Indicator_Definition__r.Score_Labels__c,new MasterScoreWrapper());
            }
            
            MasterScoreWrapper msw = wrapperMap.get(iv.Model_Indicator_Definition__r.Score_Labels__c);
            msw.inheritedValueSum += (iv.value__c==null?0:iv.value__c);
            msw.residualValueSum += (iv.Residual_Indicator_Value__c==null?0:iv.Residual_Indicator_Value__c);
            if(msw.indicator.Model_Indicator_Definition__c == null){
                msw.indicator.Model_Indicator_Definition__c = iv.Model_Indicator_Definition__c;
                msw.indicator.Name = iv.Model_Indicator_Definition__r.Score_Labels__c;
            }
            if(msw.indicator.Score__c == null){
                msw.indicator.Score__c =inheritedScore.id;
            }
             
        }
        
        List<Indicator_Value__c> ivList = new List<Indicator_Value__c>();
        
        for(MasterScoreWrapper msw :wrapperMap.values()){
            msw.indicator.value__c = msw.inheritedValueSum/count;
            msw.indicator.Residual_Indicator_Value__c = msw.residualValueSum/count;
            
            ivList.add(msw.indicator);
        }
        
        insert ivList;
        System.debug('wrapperMap...'+wrapperMap);
    }
    
    
    
    public void subCatHistories(Set<String> scoreIds, Set<String> resScoreIds){
        Map<String, Sub_Category_History__c> subCatHistoryMap = new Map<String, Sub_Category_History__c>();
        Map<String, Sub_Category_History__c> resSubCatHistoryMap = new Map<String, Sub_Category_History__c>();
        
        
        for(Sub_Category_History__c sch : [Select Model_Sub_Category_DefinitionLookup__c,Model_Sub_Category_DefinitionLookup__r.Name, Sub_Category_Score__c from Sub_Category_History__c where Score__c IN :scoreIds]){
            if(!subCatHistoryMap.containsKey(sch.Model_Sub_Category_DefinitionLookup__r.Name)){
                subCatHistoryMap.put(sch.Model_Sub_Category_DefinitionLookup__r.Name,new Sub_Category_History__c(Date_Computed__c = Date.today(),Sub_Category_Score__c=0,
                                                                                                                 Model_Sub_Category_DefinitionLookup__c = sch.Model_Sub_Category_DefinitionLookup__c,Score__c =inheritedScore.Id ));
            }
            
            Sub_Category_History__c sc = subCatHistoryMap.get(sch.Model_Sub_Category_DefinitionLookup__r.Name);
            sc.Sub_Category_Score__c = sc.Sub_Category_Score__c+(sch.Sub_Category_Score__c==null?0:sch.Sub_Category_Score__c/count); 
        }
        
        for(Sub_Category_History__c sch : [Select Model_Sub_Category_DefinitionLookup__c,Model_Sub_Category_DefinitionLookup__r.Name, Sub_Category_Score__c from Sub_Category_History__c where Score__c IN :resScoreIds]){
            if(!resSubCatHistoryMap.containsKey(sch.Model_Sub_Category_DefinitionLookup__r.Name)){
                resSubCatHistoryMap.put(sch.Model_Sub_Category_DefinitionLookup__r.Name,new Sub_Category_History__c(Date_Computed__c = Date.today(),Sub_Category_Score__c=0,
                                                                                                                 Model_Sub_Category_DefinitionLookup__c = sch.Model_Sub_Category_DefinitionLookup__c,Score__c =residualScore.Id ));
            }
            
            Sub_Category_History__c sc = resSubCatHistoryMap.get(sch.Model_Sub_Category_DefinitionLookup__r.Name);
            sc.Sub_Category_Score__c = sc.Sub_Category_Score__c+(sch.Sub_Category_Score__c==null?0:sch.Sub_Category_Score__c/count); 
        }
        
        
        List<Sub_Category_History__c> schList = new List<Sub_Category_History__c>();
        
        schList.addAll(subCatHistoryMap.values());
        schList.addAll(resSubCatHistoryMap.values());
        
        insert schList;
        System.debug('schList....'+schList.size());
    }
    
    
    
    public void CatHistories(Set<String> scoreIds, Set<String> resScoreIds){
        
        Map<String, Category_History__c> CatHistoryMap = new Map<String, Category_History__c>();
        Map<String, Category_History__c> resCatHistoryMap = new Map<String, Category_History__c>();
        
        
        for(Category_History__c sch : [Select Model_Category_DefinitionLookup__c,Model_Category_DefinitionLookup__r.Name, Category_Score__c from Category_History__c where Score__c IN :scoreIds]){
            if(!CatHistoryMap.containsKey(sch.Model_Category_DefinitionLookup__r.Name)){
                CatHistoryMap.put(sch.Model_Category_DefinitionLookup__r.Name,new Category_History__c(Date_Computed__c = Date.today(),Category_Score__c=0,
                                                                                                                 Model_Category_DefinitionLookup__c = sch.Model_Category_DefinitionLookup__c,Score__c =inheritedScore.Id ));
            }
            
            Category_History__c sc = CatHistoryMap.get(sch.Model_Category_DefinitionLookup__r.Name);
            sc.Category_Score__c = sc.Category_Score__c+(sch.Category_Score__c==null?0:sch.Category_Score__c/count); 
        }
        
        for(Category_History__c sch : [Select Model_Category_DefinitionLookup__c,Model_Category_DefinitionLookup__r.Name, Category_Score__c from Category_History__c where Score__c IN :resScoreIds]){
            if(!resCatHistoryMap.containsKey(sch.Model_Category_DefinitionLookup__r.Name)){
                resCatHistoryMap.put(sch.Model_Category_DefinitionLookup__r.Name,new Category_History__c(Date_Computed__c = Date.today(),Category_Score__c=0,
                                                                                                                 Model_Category_DefinitionLookup__c = sch.Model_Category_DefinitionLookup__c,Score__c =residualScore.Id ));
            }
            
            Category_History__c sc = resCatHistoryMap.get(sch.Model_Category_DefinitionLookup__r.Name);
            sc.Category_Score__c = sc.Category_Score__c+(sch.Category_Score__c==null?0:sch.Category_Score__c/count); 
        }
        
        
        List<Category_History__c> schList = new List<Category_History__c>();
        
        schList.addAll(CatHistoryMap.values());
        schList.addAll(resCatHistoryMap.values());
        
        insert schList;
        System.debug('schList....'+schList.size());
    }
    
    
    
    public void accountLevelScore(Set<String> scoreIds, Set<String> resScoreIds){
        
        List<AggregateResult>  inherScore = [select sum(Most_recent_score__c) score from  score__c where id IN :scoreIds];
        List<AggregateResult>  residScore = [select sum(Most_recent_score__c) score from  score__c where id IN :resScoreIds];
        
        inheritedScore.Most_recent_score__c = (Decimal)inherScore[0].get('score')/count;
        residualScore.Most_recent_score__c = (Decimal)residScore[0].get('score')/count;
        
        List<Score__c> scores =  new List<Score__c>();
        scores.add(inheritedScore);
        scores.add(residualScore);
        
        update scores;
        
    }
    
    
    
}