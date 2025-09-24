public class SOQLDemo {

    public static void parentToChildDemo(){
    	List<Account> accList = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts)
                                FROM Account WHERE Rating = 'Hot'];
        
        for(Account acc : accList){
            System.debug('Account Name : ' +acc.Name);
            for (Contact con : acc.Contacts){
                System.debug('Contacts : ' +con);
            }
        }
    }   
    
    public static void aggDemo(){
       AggregateResult[] groupedResults = [SELECT Account.Name, Sum(Amount) 
                                          FROM opportunity GROUP BY Account.Name];
        System.debug(groupedResults);
        for(AggregateResult ar : groupedResults){
            System.debug('Account ID = ' +ar.get('Name'));
            System.debug('Sum of Amount = ' + ar.get('expr0'));
        }
    }
    
    public static void queryDemo(){
        Set<Id> accIds = new Set<ID>();
        List<Account> accList = [SELECT Id FROM Account LIMIT 10] ;
        for(Account acc:accList){
            accIds.add(acc.Id);
        }
        
        List<Account> accList1 = [SELECT Id,Name,Phone,Industry,Rating FROM Account WHERE Id IN: accIds];
        for (Account acc: accList1){
            System.debug(acc);
        }
    }
}