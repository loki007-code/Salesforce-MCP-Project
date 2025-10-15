trigger ContactTrigger on Contact (after update, after insert, after delete, after undelete) {
    
    //Seperate set for storing account Ids
    Set<Id> accIds = new Set<Id>();
    
    //here getting values of inserting and undeleting count - because it always add as a new record
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)){
        if(!trigger.new.isEmpty()){
            for(Contact con: trigger.new){
                if(con.AccountId != null){
                    accIds.add(con.AccountId);
                }
            }
        }
        
    }
    
    //here while update the parent account id may changed so we are seperately writing update functionality
    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact con: trigger.new){
                if(con.AccountId != trigger.oldMap.get(con.Id).AccountId){
                    if(trigger.oldMap.get(con.Id).AccountId != null){
                        accIds.add(trigger.oldMap.get(con.Id).AccountId);
                    }
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
            }
        }
    }

	//after deleting counts may vary so wrote as a seperate    
    if(trigger.isAfter && trigger.isDelete){
        if(!trigger.old.isEmpty()){
            for(Contact con: trigger.old){
                if(con.AccountId != null) {
                    accIds.add(con.AccountId);
                }
            }
        }
    }
    
    //finally storing contacts in custom field in a account
    if(!accIds.isEmpty()){
        List<Account> accList = [SELECT Id, Total_Contact_Count__c, (SELECT Id FROM Contacts)
                                FROM Account WHERE Id IN: accIds];
        List<Account> accToBeUpdated = new List<Account>();
        if(!accList.isEmpty()){
            for(Account acc: accList){
                acc.Total_Contact_Count__c = acc.Contacts.size();
                accToBeUpdated.add(acc);
            }
        }
        
        //null checking
        if(!accToBeUpdated.isEmpty()){
            update accToBeUpdated;
        }
    }
    
    
    /*if(Trigger.isInsert){
if(Trigger.isAfter){
ContactTriggerHandler.totalContactCount(Trigger.New);
}
}

if(Trigger.isDelete){
if(Trigger.isAfter){
ContactTriggerHandler.totalContactCount(Trigger.Old);
}
}

if(Trigger.isUndelete){
if(Trigger.isAfter){

}
}

//storing parent id in set
Set<Id> accIds = new Set<Id>(); 
if(trigger.isAfter && trigger.isUpdate){
if(!trigger.new.isEmpty()){
for(Contact con : trigger.new){
if(con.AccountId != null && trigger.oldMap.get(con.Id).Description != con.Description){
accIds.add(con.AccountId);
}                
}
}
}

if(!accIds.isEmpty()){
Map<Id, Account> accMap = new Map<Id,Account>([SELECT Id, Description FROM Account WHERE Id IN : accIds]);
List<Account> listToBeUpdated = new List<Account>();
if(!trigger.new.isEmpty()){
for(Contact cont : trigger.new){
Account acc = accMap.get(cont.AccountId);
acc.Description = cont.Description;
listToBeUpdated.add(acc);
}
}
if(!listToBeUpdated.isEmpty()){
update listToBeUpdated;
}
}
*/
    
}