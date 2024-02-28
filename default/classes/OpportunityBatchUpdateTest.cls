@isTest
public with sharing class OpportunityBatchUpdateTest {
    @isTest 
    static void testOpportunityUpdate() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i, Industry = 'Technology'));
        }
        insert testAccounts;

        List<Opportunity> testOpportunities = new List<Opportunity>();
        for (Account acc : testAccounts) {
            testOpportunities.add(new Opportunity(
                Name = 'Test Opportunity for ' + acc.Name,
                StageName = 'Open',
                CloseDate = Date.today(),
                AccountId = acc.Id
            ));
        }
        insert testOpportunities;

        OpportunityBatchUpdate batch = new OpportunityBatchUpdate(testAccounts);

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        testOpportunities = [SELECT CloseDate FROM Opportunity WHERE Id IN :testOpportunities];

        Date expectedCloseDate = [SELECT EndDate FROM Period WHERE Type = 'Quarter' AND StartDate = THIS_FISCAL_QUARTER LIMIT 1].EndDate;
        
        for (Opportunity opp : testOpportunities) {
            System.assertEquals(expectedCloseDate, opp.CloseDate, 'The Close Date should be updated to the end of the current quarter.');
        }
    }
}
