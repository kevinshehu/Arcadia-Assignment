@isTest
public with sharing class OpportunityBatchUpdateTest {
    @isTest 
    static void testOpportunityUpdate() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Open',
            CloseDate = Date.today(),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        List<Account> accountsList = new List<Account>{testAccount};
        OpportunityBatchUpdate batch = new OpportunityBatchUpdate(accountsList);

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        testOpportunity = [SELECT CloseDate FROM Opportunity WHERE Id = :testOpportunity.Id];

        Date expectedCloseDate = [SELECT EndDate FROM Period WHERE Type = 'Quarter' AND StartDate = THIS_FISCAL_QUARTER LIMIT 1].EndDate;
        System.assertEquals(expectedCloseDate, testOpportunity.CloseDate, 'The Close Date should be updated to the end of the current quarter.');
    }
}