public with sharing class HotAccountFetcher {
    @AuraEnabled(cacheable=true)
    public static List<Account> getHotAccounts() {
    return [SELECT Id, Name, Rating, Industry, Phone, Type, OwnerId FROM Account WHERE Rating = 'Hot' LIMIT 10];
    }
}