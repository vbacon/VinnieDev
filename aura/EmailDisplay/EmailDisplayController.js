({
	doInit : function(component, event, helper) {
		console.log(component.get("v.pageReference").state.Id);
        //component.set('v.theTaskId', ("v.pageReference").state.Id);
        //helper.getTaskInfo(component, event);
	}
})