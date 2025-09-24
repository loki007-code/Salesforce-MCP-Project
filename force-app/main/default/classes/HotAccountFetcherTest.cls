@isTest
public class HotAccountFetcherTest {
    @isTest
    static void testGetHotAccounts() {
        // Create 15 Accounts, 12 with Rating 'Hot', 3 with other ratings
        List<Account> accs = new List<Account>();
        for(Integer i=0; i<12; i++) {
            accs.add(new Account(Name='Hot Account ' + i, Rating='Hot', Phone='1234567890'));
        }
        for(Integer i=0; i<3; i++) {
            accs.add(new Account(Name='Other Account ' + i, Rating='Warm', Phone='1234567890'));
        }
        insert accs;
        
        Test.startTest();
        List<Account> hotAccounts = HotAccountFetcher.getHotAccounts();
        Test.stopTest();
        
        System.assertEquals(10, hotAccounts.size(), 'Should return only 10 hot accounts');
        for(Account acc : hotAccounts) {
            System.assertEquals('Hot', acc.Rating, 'Account rating should be Hot');
        }
    }
}