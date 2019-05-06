trigger TaskTrigger on Task (before insert) {
    new TaskTriggerHandler().run();
}