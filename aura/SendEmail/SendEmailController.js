({
    sendEmail : function(component, event, helper) {
        //Setup the call to the Apex Controller and also pass one parameter
        var action = component.get("c.sendEnvelope");
        
        action.setParams({"contactId": component.get("v.recordId")});
        // Configure response handler 
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            
            if (state === "SUCCESS") {
                //set response value in responseMessage attribute on component.
                console.log(response.getReturnValue());
                component.set('v.responseMessage', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
 })