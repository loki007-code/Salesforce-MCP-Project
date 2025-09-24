public class ApexScenariosDemo {
    
    public static void apexScenario4(){
       List<Account> accList = new List<Account>();
         accList = [SELECT Id,Total_Contact_Count__c,Active__c, (SELECT Id FROM Contacts)
                   FROM Account WHERE CreatedDate = THIS_YEAR];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                acc.Total_Contact_Count__c = acc.Contacts.size();
                if(acc.Active__c == null){
                    acc.Active__c = 'Yes';
                }
            }
            update accList;
        }
    }
    
    public static void apexScenario3(){
       	List<Opportunity> oppList = new List<Opportunity>();
        
        oppList = [SELECT Id,StageName FROM Opportunity 
                   WHERE CreatedDate = THIS_YEAR];
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(opp.StageName == 'Closed Won'){
                    opp.Description = 'Opportunity is Closed Won';
                }else if(opp.StageName == 'Closed Lost'){
                    opp.Description = 'Opportunity is Closed Lost';
                }else{
                    opp.Description = 'Opportunity is Open';
                }
            }
            update oppList;
        }
    }
    
    public static void apexScenario2(){
        List<Account> accList = new List<Account>();
        
        accList = [SELECT Id,Name, (SELECT Id, Amount FROM Opportunities)
                   FROM Account WHERE Phone != null];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                Decimal total = 0;
                for(Opportunity opp : acc.Opportunities){
                    if(opp.amount != null){
                        total += opp.amount;
                    }
                }
                System.debug(acc.Name + ' has ' + total + ' worth Opportunities ');
            }
        }
    }
    
    public static void apexScenario1(){
        List<Account> accList = new List<Account>();
        
        accList = [SELECT Id,Name, (SELECT Id FROM Contacts)
                   FROM Account WHERE Phone != null];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                System.debug(acc.Name + ' has ' + acc.Contacts.size() + ' Contacts related ');
            }
        }
    }
}