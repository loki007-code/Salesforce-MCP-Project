public with sharing class SelfCertificationAdminController {
    
    @AuraEnabled(cacheable=true)
    public static List<Self_Certification__c> getAllCertifications() {
        return SelfCertificationHandler.getCertifications();
        //return [SELECT Id, Country__c, Certification_Date__c, Certified_By__r.Name,Certified_By__r.Id, Status__c, Next_Due_Date__c, Email__c FROM Self_Certification__c];
    }
}