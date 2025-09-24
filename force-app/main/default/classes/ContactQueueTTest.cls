/*
**********************************************************************************************************************
Apex Class Name    : ContactQueueT
Created Date       : 18-04-2025
@author            : Logesh Aravindh
Modification Log:
Ver   	Date         		Author                               Modification
1.0   	18-04-2025   		Logesh Aravindh                      Initial Version
**********************************************************************************************************************
*/

/**
* @description Test class for ContactQueueT
*/@isTest
public class ContactQueueTTest {
    
    /**
* @description To create a collection of Contact records and updates its email and check whether it is updates or not 
**/        
    @isTest
    static void testEmailUpdate(){
        List<Contact> conList = new List <Contact>();
        
        for(integer i=0; i<10; i++){
            conList.add(new Contact(LastName = 'Queue Test' + i));
        } 
        
        if(!conList.isEmpty()){
            insert conList;
        }
        
        List<Id> conIds = new List<Id>();
        for(Contact con : conList){
            conIds.add(con.Id);
        }
        
        Test.startTest();
        System.enqueueJob(New ContactQueueT(conIds));
        Test.stopTest();
        
        List<Contact> updContacts = [SELECT Email FROM Contact WHERE Id in :conIds];
        for(Contact con : updContacts){
            System.assertEquals('test@gmail.com',con.Email,'Email does not match');
        }
    }
}