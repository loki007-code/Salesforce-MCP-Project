/*
**********************************************************************************************************************
Apex Class Name    : Account Trigger Handler test
Created Date       : 18-04-2025
@author            : Logesh Aravindh
Modification Log:
Ver   	Date         		Author                               Modification
1.0   	18-04-2025   		Logesh Aravindh                      Initial Version
**********************************************************************************************************************
*/@isTest
public class AccountTriggerTHandlerTest {
    
    @isTest
    public static void testUpdatePhone(){
        List<Account> accList = new List<Account> ();
        
        Account acc = new Account(Name = 'Trumatics test', Phone = '1111111111');
        insert acc;
        
        Contact con = new Contact(LastName = 'Test', AccountId = acc.Id);
        insert con;
        
        acc.Phone = '2324561897';
        update acc;
        
        Map<Id, Account> oldMap = new Map<Id, Account>{
            acc.Id => new Account(Id = acc.Id, Phone = '1111111111')
        };
        
        Test.startTest();
        AccountTriggerTHandler.updatePhone(new List<Account>{ acc }, oldMap);
        Test.stopTest();
        
        Contact updContact = [SELECT Phone, OtherPhone FROM Contact WHERE Id = :con.Id];
		System.assertEquals('2324561897', updContact.Phone, 'Phone should be updated');
        System.assertEquals('2324561897', updContact.OtherPhone, 'Phone should be updated');
   	}
}