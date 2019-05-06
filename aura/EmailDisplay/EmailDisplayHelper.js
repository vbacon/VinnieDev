({
   
    getTaskInfo : function(component, event) {
        const theTaskId = component.get('c.TaskId');
        console.log('theTaskId = '+ theTaskId);
        
        var action = component.get('c.getTaskData');

        console.log('action '+ action);
        action.setParams({ recordId : theTaskId });
        action.setCallback(this, function(response) {                
            component.set('v.theEmail', response.getReturnValue());
        });
        $A.enqueueAction(action);
        console.log('Task subject = ' + v.theEmail.Subject);
    },
})