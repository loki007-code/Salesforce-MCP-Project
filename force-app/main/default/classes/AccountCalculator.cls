public class AccountCalculator {

    @future
    public static void countContacts(List<Id> accIds){
        List <Account> accList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: accIds];
        for(Account acc : accList){
            acc.Count_Number_Of_Contacts__c = acc.Contacts.size();
        }
        
        if(!accList.isEmpty()){
            update accList;
        }
    }
}