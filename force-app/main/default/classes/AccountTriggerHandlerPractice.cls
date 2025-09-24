public class AccountTriggerHandlerPractice {

    public static void beforeInsert(List<Account> newList){
        for(Account acc : newList){
            if(acc.Name.contains('Test')){
                acc.Description = 'Name with test is created';
            }
        }        
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap){
        for(Account acc : newList){
            Account oldAcc = oldMap.get(acc.Id);
            if(acc.Name != oldAcc.Name){
                acc.Description = 'Name changed';
            }
        }
    }
}