public class TaskTriggerHandler extends TriggerHandler {
    
    public TaskTriggerHandler() {
    
    }
    
    Protected override void beforeInsert() {
        setPublicField();
    }
    
    private void setPublicField() {
        for (Task theTask : (List<Task>) Trigger.new) {
            if (theTask.Subject.substring(0, 5) == 'Email') {
                theTask.IsVisibleInSelfService = true;    
            }
        }
    }
        
    
}