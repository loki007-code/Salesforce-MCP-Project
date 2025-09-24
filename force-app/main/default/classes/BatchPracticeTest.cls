@isTest
public class BatchPracticeTest {
    @testSetup
    public static void setup(){
        List<Account> accList = new List <Account>();
        for(integer i=0; i<10; i++){
            accList.add(new Account(Name = 'Batch Practice' + i, Active__c = 'Yes'));
        } 
        insert accList;
    }
    
    @isTest
    public static void testBatchPractice(){
        Test.startTest();
        BatchPractice bp = new BatchPractice();
        Database.executeBatch(bp);
        Test.stopTest();
        
        List <Account> updatedAccList = [SELECT Name FROM Account WHERE Name LIKE 'Batch Practice%'];
        for(Account acc : updatedAccList){
            System.assert(acc.Name.Contains('Batch'));
        }
    }
}