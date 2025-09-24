public class AccountTriggerHandler {
    
    public static boolean handleAccount(list <Account> accList){
        System.debug('Trigger is executing: ' + Trigger.isExecuting);
        
        if(Trigger.isExecuting){
            //do whatever you want to do as part of trigger invocation
            System.debug('Trigger is executing: ' + Trigger.isExecuting);
        }else{
            // do whatever you want to do if the call orignated from different context
            System.debug('Without Trigger');
        }
        
        return Trigger.isExecuting;
    }
    
    //47
    public static void preventDeletion(List<Account> accList){
        
        Profile p = [SELECT ID FROM Profile WHERE Name = 
                    'System Administrator'];
        for(Account acc : accList){
            if( UserInfo.getProfileId() != p.Id && acc.Active__c == 'Yes'){
                acc.addError(Label.prevent_Account_Deletion);
            }
        }
    }
    
    public static void updateRelatedContact(List<Account> accList, Map<Id, Account> accOldMap){
        List<Contact> conList = new List<Contact>();
        Map<Id, Account> accMap = new Map<Id,Account>();

        for(Account acc : accList){
            //Map will store only those accounts whose phone is updated
            if(acc.Phone != null && acc.Phone != accOldMap.get(acc.Id).Phone){
                accMap.put(acc.Id, acc);
            }
        }
        
        for(Contact con : [SELECT Id, HomePhone, AccountId FROM Contact
                         WHERE AccountId IN: accMap.keySet()]){
                             if(accMap.containsKey(con.AccountId)){
                                 con.HomePhone = accMap.get(con.AccountId).Phone;
                                 conList.add(con);
                             }
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }
    
    public static void populateRating(List<Account> accList, Map<Id, Account> accOldMap){
        for(Account acc : accList){
            if((accOldMap == null && acc.Industry != null && acc.Industry == 'Media')||
               (accOldMap != null && acc.Industry != null && acc.Industry != accOldMap.get(acc.Id).Industry && acc.Industry == 'Media')){
                acc.Rating = 'Hot';
            }
        }
    }
    
    public static void updatePhone(List<Account> accList, Map<Id, Account> accOldMap){
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                acc.Description = 'Phone is updated, old value = '
                    + accOldMap.get(acc.Id).Phone + ' New value = '
                    +acc.Phone;
            }
        }
    }
    
    public static void createOpp(List<Account> accList){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc : accList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.CloseDate = System.today();
            opp.StageName = 'Prospecting';
            opp.AccountId = acc.Id;
            opp.Amount = 10000;
            oppList.add(opp);
        }
        
        //if(!oppList.isEmpty()){
          //  insert oppList;
        //}
        
        Database.SaveResult[] srList = Database.insert(oppList, false);
        for(Integer i = 0; i < srList.size(); i++){
            if(!srList[i].isSuccess()){
                String errors = '';
                for(Database.Error err : srList[i].getErrors()){
                    errors += err.getMessage();
                }
                accList[i].addError(errors);
            }
        }
    }
    
    public static void updateDesc (List<Account>  accList){
        for(Account acc : accList){
            //Tigger.New is A sObject list
            acc.Description = 'Account is created';
        }
    }
    
    public static void populateRating(List<Account> accList){
        for(Account acc : accList){
            if(acc.Industry != null && acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
        }
    }
}