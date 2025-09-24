trigger OpportunityTrigger on Opportunity (before insert, after update) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            OpportunityTriggerHandler.validateAmount(Trigger.New);
        }
    }
    if(Trigger.isupdate){
        if(Trigger.isAfter){
            if(!preventRecursion.firstCall){
                preventRecursion.firstCall = true;
                OpportunityTriggerHandler.updateDesc(Trigger.New, Trigger.oldMap);
            }
        }
    }
}