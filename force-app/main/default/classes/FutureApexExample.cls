global class FutureApexExample {
    //Primitive - data type - Integer, String, List Id, Set I
    @future
    public static void futureMethod(){
    }
    @future
    public static void countContacts(List<Id> accIds){
        If(accIds == null || accIds.isEmpty()){
            return;
        }
        List<Account> accList = [SELECT Id,Name,Number_Of_Contacts__c,(SELECT ID, Name FROM Contacts) 
                                 FROM Account WHERE Id IN: accIds];
        //List<Contact> conList = [SELECT Id,Name,Account.Name,Account.Id FROM Contact];
        //
        for(Account acc : accList){
            acc.Number_Of_Contacts__c = acc.Contacts.size();
        }
        if(!accList.isEmpty()){
            update accList;   
        }
        
        //for(Account acc : accList){
          //  if(acc.Number_Of_Contacts__c != null){
          //      System.debug('Account Name: ' + acc.Name);
          //      System.debug('Contact Size: ' + acc.Number_Of_Contacts__c);
          //  }
        //}
        
    }
 
}