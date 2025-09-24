@isTest
public class AccountTriggerHandlerPracticeTest {

    @isTest
    public static void testBeforeInsert(){
        Account acc = new Account(Name = 'test', Active__c = 'Yes');
        insert acc;
        
        Account resultAcc = [SELECT Id,Name,Description FROM Account WHERE Id =: acc.Id];
        System.assertEquals('Auto Description', resultAcc.Description);
    }
    
    @isTest
    public static void testBeforeUpdate(){
         Account acc = new Account(Name = 'test', Active__c = 'Yes');
        insert acc;
        
        acc.Name = 'testx';
        update acc;
        
        Account resultAcc = [SELECT Id,Name,Description FROM Account WHERE Id =: acc.Id];
        System.assertEquals('Name has been changed', resultAcc.Description);
        
    }
}