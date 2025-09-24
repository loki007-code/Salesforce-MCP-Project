trigger AccountTrigger on Account (before insert, after insert, before update, before delete, after update) {

    if(trigger.isBefore && trigger.isInsert && (trigger.isInsert || trigger.isUpdate)){
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                if(acc.phone == null){
                    acc.addError('You must need to have phone field updated');
                }
                if(acc.BillingStreet != null){
                    acc.ShippingStreet = acc.BillingStreet;
                }
                if(acc.BillingCity != null){
                    acc.ShippingCity = acc.BillingCity;
                }
                if(acc.BillingState != null){
                    acc.ShippingState = acc.BillingState;
                }
                if(acc.BillingPostalCode != null){
                    acc.ShippingPostalCode = acc.BillingPostalCode;
                }
                if(acc.BillingCountry != null){
                    acc.ShippingCountry = acc.BillingCountry;
                }
            }
        }
        
        //scenario 3
        Map<Id,Account> accMap = new Map<Id, Account>(); //used to update child value
        if(trigger.isAfter && trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Account acc: trigger.new){
                    if(trigger.oldMap.get(acc.Id).Phone != acc.Phone){
                        accMap.put(acc.Id,acc);
                    }
                }
            }
        }
        
        //fetch all contacts related to account
        List<Contact> conList = [SELECT Id,AccountId,Phone FROM Contact WHERE AccountId IN: accMap.keySet()];
        
        //TO update we need to perform DML operation, but it is not good to perform DML operation inside a loop so we are creating a new List and update the List.
        List<Contact> listToUpdateContacts = new List<Contact>();
        if(!conList.isEmpty()){
            for(Contact con : conList){
                con.Phone = accMap.get(con.AccountId).Phone;
            }
        }
        if(!listToUpdateContacts.isEmpty()){
            update listToUpdateContacts;
        }
    }
    
    
    
    //Sanjay gupta scenarios
    /**
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerHandler.updateDesc(Trigger.New);
            AccountTriggerHandler.populateRating(Trigger.New, null);
        }else if(Trigger.isAfter){
            //here after insert trigger.new is read only
            AccountTriggerHandler.createOpp(Trigger.New);
            Boolean b = AccountTriggerHandler.handleAccount(Trigger.New);
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerHandler.updatePhone(Trigger.New, Trigger.oldMap);
            AccountTriggerHandler.populateRating(Trigger.New, Trigger.oldMap);
        }else if(Trigger.isAfter){
            AccountTriggerHandler.updateRelatedContact(Trigger.New, Trigger.oldMap);
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
             AccountTriggerHandler.preventDeletion(Trigger.old);
        }else if(Trigger.isAfter){
            
        }
    }
	**/
}