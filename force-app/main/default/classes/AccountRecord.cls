public class AccountRecord {
    
    public static ID insertAccount(String name, String rating, String active){
        Account acc = new Account();
        acc.name = name;
        acc.Rating = rating;
        acc.Active__c = active;
        insert acc;
        return acc.Id; //after creation of acc rec return id
    }
    
    public static void insertContact(){
        Id accId;
        accId = insertAccount('lokicode4','Hot','Yes');
        Contact con = new Contact(FirstName = 'Contact 101', LastName = 'Con 201');
        con.accountId = accId;
        insert con;
    }
    
    public static void insertAccountWithConAndOpp(String name, String rating, String active){
        Account acc = new Account();
        acc.name = name;
        acc.Rating = rating;
        acc.Active__c = active;
        insert acc;
        
        Contact con = new Contact(FirstName = 'Contact 101', LastName = 'Con 201');
        con.accountId = acc.Id;
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp 101';
        opp.CloseDate = System.today();
        opp.StageName = 'Prospecting';
        opp.AccountId = acc.Id;
        insert opp;
    }
    
}