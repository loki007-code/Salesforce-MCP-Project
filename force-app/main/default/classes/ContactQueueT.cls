/*
**********************************************************************************************************************
Apex Class Name    : ContactQueueT
Created Date       : 18-04-2025
@author            : Logesh Aravindh
Modification Log:
Ver   	Date         		Author                               Modification
1.0   	18-04-2025   		Logesh Aravindh                      Initial Version
**********************************************************************************************************************
*/

/**
* @description Takes a list of Contact IDs and updates the email field to a default value
*/
public class ContactQueueT implements Queueable {
    
    private List<Id> contactIds;
    
    public ContactQueueT(List<Id> contactIds){
        this.contactIds = contactIds;
    }
    
    /**
* @description To get collection of emails using contact Id and update it
**/    
    public void execute(QueueableContext qtx){
        List<Contact> conList = [SELECT Id, Email FROM Contact WHERE Id IN :contactIds];
        for(Contact con: conList){
            con.Email = 'test@gmail.com';
        }
        
        if (!conList.isEmpty()) {
            update conList;
        }
    }
}