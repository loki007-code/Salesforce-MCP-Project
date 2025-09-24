global class BatchPractice implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext btx){
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    
    global void execute(Database.BatchableContext btx, List <Account> accList){
        for(Account acc : accList){
            acc.Name += 'Batch Practice';
        }
        update accList;
    }
    
    global void finish(Database.BatchableContext btx){
        System.debug('Batch Completed');
    }
}