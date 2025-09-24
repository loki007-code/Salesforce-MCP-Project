@isTest
public class AccountTriggerHandlerTest {
	@isTest
    static void createOppTest(){
        List <Account> accList = new List<Account>();
        for(Integer i=1; i<=10; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List <Opportunity> oppList = [SELECT Id FROM Opportunity
                                     WHERE AccountId =: accList[0].Id];
        System.assert(oppList != null, 'Opportunity is not created');
    }
    
    @isTest
    static void populateRatingInsert(){
        List <Account> accList = new List<Account>();
        for(Integer i=1; i<=10; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i;
            acc.Active__c = 'Yes';
            acc.Industry = 'Media';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List <Account> updatedAccList = [SELECT Rating FROM
                                        Account WHERE Id =:accList[0].Id];
        System.assertEquals('Hot', updatedAccList[0].Rating);
    }
    
    @isTest
    static void populateRatingUpdate(){
        List <Account> accList = new List<Account>();
        for(Integer i=1; i<=10; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i;
            acc.Active__c = 'Yes';
            acc.Industry = 'Chemicals';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        for(Account acc : accList){
            acc.Industry = 'Media';
        }
        update accList;
        Test.stopTest();
        
        List <Account> updatedAccList = [SELECT Rating FROM
                                        Account WHERE Id =:accList[0].Id];
        System.assertEquals('Hot', updatedAccList[0].Rating);
    }
}