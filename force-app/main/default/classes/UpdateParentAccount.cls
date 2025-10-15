public class UpdateParentAccount implements Queueable {

    private List<Account> accList;
    private Id parentAccId;
    
    public UpdateParentAccount (List <Account> accRecords, Id accId){
        this.accList = accRecords;
        this.parentAccId = accId;
    }
    
    public void execute(QueueableContext context){
        for(Account acc : accList){
            acc.ParentId = ParentAccId;
        }
        update accList;
    }
}