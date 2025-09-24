@isTest
public class DailyOppProcessorTest {
    
    @isTest
    private static void testScheduleApex(){
        String sch = '0 0 0 ?  * * *';
        List <Opportunity> oppList = new List <Opportunity>();
          for(Integer i=0; i<500; i++){
            if(i<250){
                oppList.add(new Opportunity (Name = 'Test' + i, Amount = 1000,
                                             StageName = 'Prospecting', CloseDate = System.today()));
            }else{
                oppList.add(new Opportunity (Name = 'Test' + i, Amount = 1000,
                                             StageName = 'Prospecting', CloseDate = System.today(),LeadSource = 'Email'));
            }
        }
        insert oppList;
        Test.startTest();
        String JobId = System.schedule('Process Opps',sch, new DailyOppProcessor());
        Test.stopTest();
        
       List<Opportunity> updatedOpps = new List<Opportunity> ();
       updatedOpps = [SELECT Id, LeadSource FROM Opportunity
                                     WHERE LeadSource = 'Web'];
       System.assertEquals(250, updatedOpps.size());
    }
}