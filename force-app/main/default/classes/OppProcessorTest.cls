@isTest
public class OppProcessorTest {

    @isTest
    private static void testBatchClass(){
        List <Opportunity> oppList = new List <Opportunity> ();
        
        for(Integer i=0; i<200;i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'test'+i;
            opp.CloseDate = System.today();
            opp.StageName = 'Prospecting';
            opp.Amount = 123456;
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        OppProcessor opp =new OppProcessor();
        Id batchId = Database.executeBatch(opp,200);
        Test.stopTest();
        
        List <Opportunity> updateOpp = [SELECT Id FROM Opportunity WHERE LeadSource = 'Web'];
        System.assertEquals(200, updateOpp.size());
    }
}