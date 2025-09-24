public class DMLDemo {
    
    public static void databaseClassDemo(){
        List<Contact> conList = new List<Contact>{
            new Contact(FirstName='Joe',LastName='Smith',Department='Technology'),
            new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
            new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
            new Contact()
        };
            
        Database.SaveResult[] srList = Database.insert(conList, false);
        
        //Iterate through each returned result
        for(Database.SaveResult sr: srList){
            if(sr.isSuccess()){
                //operation was successfull, so get the ID of the record that was processed
                System.debug('Successfully inserted contact. Contact ID:  ' + sr.getId());
            }else{
                //Operation failed
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following errors has occured');
                    System.debug(err.getStatusCode() + ':' + err.getMessage());
                    System.debug('Contact field that affected this error: ' +err.getFields());
                }
            }
        }
    }
    
    public static void deleteDemo(){
        List <Account> accList = new List<Account>();
        //deleting rows
        accList = [SELECT Id,Name,Rating FROM Account WHERE Name LIKE 
                  'Test Upsert %' ALL ROWS];
        
        //undeleting rows
        /*
        accList = [SELECT Id,Name,Rating FROM Account WHERE Name LIKE 
                  'Test Upsert %'];
        
        if(!accList.isEmpty()){
            delete accList;
        }
		*/
    }
    
    public static void updateDemo(){    
        List <Account> accList = new List<Account>();
        
        accList = [SELECT Id,Name,Rating FROM Account WHERE Rating = 'Hot'];
        
        if(!accList.isEmpty()){
            for(Account acc : accList){
                acc.Industry = 'Energy';   
            }
            //update accList;
        }
        
        try{
            for(Integer i=1; i<=5; i++){
            Account acc = new Account();
            acc.Name = 'Test Upsert' + i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            upsert accList; //used to both update and insert data
        }
        }
        catch(DMLException e){
            System.debug(e);
        }
       
         
    }

    public static void insertDemo() {
        List<Account> accList = new List<Account>();
        //List<Contact> conList = new List<Contact>();
        
        //inside multiple records
        /*for(int i =1; i<=200) {
            Account acc = new Account();
            acc.Name = 'Test DML Test' + i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }*/
        
        //insert accList;
        
        /* insert account and related contact records
        Account acc = new Account();
        acc.Name = 'Test DML 104';
        acc.Active__c = 'Yes';
        //insert acc;
        accList.add(acc);
        
        Account acc1 = new Account();
        acc1.Name = 'Test DML 105';
        acc1.Active__c = 'Yes';
        //insert acc1;
        accList.add(acc1);
        
       	insert accList;
        
        Contact con = new Contact();
        con.FirstName = acc.Name;
        con.LastName = acc.Name;
        con.AccountId = accList[0].Id;
        conList.add(con);
        
        
        Contact con1 = new Contact();
        con1.FirstName = acc1.Name;
        con1.LastName = acc1.Name;
        con1.AccountId = accList[1].Id;
        conList.add(con1);
        
        
        insert conList;
        //System.debug('Account Id = ' + acc.Id);
        //*/
    }
}