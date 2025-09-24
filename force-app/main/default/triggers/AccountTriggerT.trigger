/*
**********************************************************************************************************************
Apex Trigger Name    : AccountTriggerT
Created Date       : 18-04-2025
@author            : Logesh Aravindh
Modification Log:
Ver   	Date         		Author                               Modification
1.0   	18-04-2025   		Logesh Aravindh                      Initial Version
**********************************************************************************************************************
*/

/**
* @description Creating trigger handler for update contacts in phone after modified phone in accounts
*/
trigger AccountTriggerT on Account (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            AccountTriggerTHandler.updatePhone(Trigger.New, Trigger.oldMap);
        }
    }
}