/*
**********************************************************************************************************************
Apex Class Name    : AccountTriggerTHandler
Created Date       : 18-04-2025
@author            : Logesh Aravindh
Modification Log:
Ver   	Date         		Author                               Modification
1.0   	18-04-2025   		Logesh Aravindh                      Initial Version
**********************************************************************************************************************
*/

/**
* @description Phone is modified on account object then update contact record with phone field 
other phone field with old value and home phone field with new value
*/
public class AccountTriggerTHandler {
    
    public static void updatePhone(List<Account> accList, Map<Id, Account> accOldMap){
        
        List<Contact> conList = new List<Contact>();
        Map<Id, Account> accMap = new Map<Id,Account>();
        
        for(Account acc : accList){
            if(acc.Phone != null && acc.Phone != accOldMap.get(acc.Id).Phone){
                accMap.put(acc.Id, acc);
            }
        }
        
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                for(Contact con : [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN: accMap.keySet()]){
                    if(accMap.containsKey(con.AccountId)){
                        con.OtherPhone = accMap.get(con.AccountId).Phone;
                        con.Phone = acc.Phone;
                        conList.add(con);
                    }
                }
            }
        }
        
        if(!conList.isEmpty()){
            update conList;
        }
    }
}