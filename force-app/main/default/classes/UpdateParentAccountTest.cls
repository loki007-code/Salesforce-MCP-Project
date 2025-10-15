@isTest
public class UpdateParentAccountTest {

    @testSetup
    static void setup(){
        List <Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Parent', Active__c = 'Yes'));
        
        for(Integer i = 0; i<100; i++){
            accList.add(new Account(name = 'Test Account' + i, Active__c = 'Yes'));
        }
        insert accList;
    }
    
    @isTest
    private static void testQueueable(){
        Id parentId = [SELECT Id FROM Account WHERE Name = 'Parent'][0].id;
        List<Account> accList = [SELECT Id,Name FROM Account WHERE Name LIKE 'Test Account%'];
        
        UpdateParentAccount updateJob = new UpdateParentAccount(accList, parentId);
        Test.startTest();
		System.enqueueJob(updateJob);
        Test.stopTest();
        
        System.assertEquals(100,[SELECT Count() FROM Account WHERE parentId =: parentId]);
    }
}