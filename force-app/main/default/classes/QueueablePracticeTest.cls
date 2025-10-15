@isTest
public class QueueablePracticeTest {

    @testSetup
    public static void dataSetup(){
        List<Account> accList = new List <Account>();
        for(integer i=0; i<10; i++){
            accList.add(new Account(Name = 'Queue Practice' + i, Active__c = 'Yes'));
        } 
        insert accList;
    }
    
    @isTest
    public static void testQueue(){
        Test.startTest();
        System.enqueueJob(New QueueablePractice());
        Test.stopTest();
        
        List<Account> accList = [SELECT Name FROM Account WHERE Name LIKE 'Queue Practice%'];
        for(Account acc : accList){
            System.assert(acc.Name.startsWith('Queue'));
        }
    }
}