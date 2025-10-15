public with sharing class ContactCounterController {
  @AuraEnabled(cacheable=true)
  public static Integer getTotalContacts() {
    return [SELECT COUNT() FROM Contact];
  }
}
