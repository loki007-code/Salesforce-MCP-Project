public class ContactTriggerHandler {

    public static void totalContactCount(List<Contact> conList){
        List<Account> accList = new List<Account>();
        Set<id> accIds = new Set<Id>();
        
        for(Contact con : conList){
            if(con.AccountId != null){
                //collect all account ids
                accIds.add(con.AccountId);
            }
        }
        
        for(Account acc : [SELECT Id, (SELECT Id FROM Contacts)
                           FROM Account WHERE Id IN: accIds]){
                               acc.Total_Contact_Count__c = acc.Contacts.size();
                               accList.add(acc);
                           }
        if(!accList.isEmpty()){
            update accList;
        }
    }
}