public class OppProcessor implements Database.Batchable<sObject>, Database.stateful {

    public integer recordCount = 0;
    
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, LeadSource FROM Opportunity]);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> oops ){
        if(!oops.isEmpty()){
            for(Opportunity opp : oops){
                opp.LeadSource = 'Web';
            }
        }
        update oops;
        recordCount = recordCount + oops.size();
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Total records processed: '+ recordCount);
    }
}