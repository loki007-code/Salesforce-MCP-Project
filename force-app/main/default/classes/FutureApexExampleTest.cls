@isTest
public class FutureApexExampleTest {
    
    @isTest
    static void countContactTest(){
        //insert account 
        List <Account> accList = new List<Account>();
        for(Integer i=1; i<=10; i++){
            Account acc = new Account();
            acc.Name = 'Test' + i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        //Test.startTest();
        insert accList;
        //Test.stopTest();
        
        //insert contact related to account
        List <Contact> conList = new List<Contact>();
        Contact con1 = new Contact();
        con1.LastName = 'Testcon1';
        con1.AccountId = accList[0].Id;
        conList.add(con1);
        
        Contact con2 = new Contact();
        con2.LastName = 'Testcon2';
        con2.AccountId = accList[1].Id;
        conList.add(con2);
        
        //Test.startTest();
        insert conList;
        //Test.stopTest();
        
        //get accIds
        List <Id> accIds = new List <Id>();
        for(Account acc : accList){
            accIds.add(acc.Id);
        }
        
        Test.startTest();
        //insert accList;
        //insert conList;
        FutureApexExample.countContacts(accIds);
        Test.stopTest();
        
        //getting accounts data to validate
        List<Account> updatedAcc =  [SELECT Id,Name,Number_Of_Contacts__c,(SELECT ID, Name FROM Contacts) 
                                     FROM Account WHERE Id IN: accIds];
        
        //getting size of contact and checking number of contacts in variable in account obj
        for(Account acc : updatedAcc){
            System.assertEquals(acc.Contacts.size(),acc.Number_Of_Contacts__c.intValue(),'These account getting error '+acc.Name);
        }
    }
    
    @isTest
    static void testWithEmptyId() {
        Test.startTest();
        FutureApexExample.countContacts(new List<Id>());
        Test.stopTest();
    }
    
}