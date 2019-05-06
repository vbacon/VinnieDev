trigger BankAccountTrigger on BankAccount__c(after insert, after update) {
  new BankAccountTriggerHandler().run();
}