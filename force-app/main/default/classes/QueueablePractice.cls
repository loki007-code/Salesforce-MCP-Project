public class QueueablePractice implements Queueable {

    public static void execute(QueueableContext qtx){
        List<Account> accList = [SELECT Id,Name FROM Account];
        for(Account acc: accList){
            acc.Name += 'Queue Test'; 
        }
        update accList;
    }
}