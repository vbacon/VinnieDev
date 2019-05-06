({
	doInit : function(component, event, helper) {

        if(component.get("v.accountId")){
           var action = component.get("c.createEachCategoryScoreMap");   
            
            action.setParams({
                "accountId": component.get("v.accountId"),
                "scoreType": component.get("v.scoreType")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                  
                    var mapDataValues = response.getReturnValue();
                    for(var key in mapDataValues){
                        
                        if(key=='Overall Risk Score'){
                            component.set('v.ovarAllRiskVal',mapDataValues[key]);
                        }else if(key=='Transactional'){
                            component.set('v.transactionalVal',mapDataValues[key]);
                        }else if(key=='Reputational'){                        	
                            component.set('v.reputationalVal',mapDataValues[key]);
                        }else if(key=='Operational'){
                            component.set('v.operationsVal',mapDataValues[key]);
                        }else if(key=='Regulatory'){
                            component.set('v.regulatoryVal',mapDataValues[key]);
                        }else if(key=='Ownership'){
                            component.set('v.ownershipVal',mapDataValues[key]);
                        }
                    }
                    component.set('v.isDataLoaded',true);
                }
            });
            $A.enqueueAction(action); 
       }
	}
})