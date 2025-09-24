trigger AccountTriggerPractice on Account (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
        AccountTriggerHandlerPractice.beforeInsert(Trigger.new);
    }else if(Trigger.isUpdate && Trigger.isBefore){
        AccountTriggerHandlerPractice.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
}