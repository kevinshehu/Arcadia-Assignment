@isTest
public with sharing class AccountTriggerHandlerTest {
    @isTest static void testBeforeUpdate() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i, Industry = 'Banking'));
        }
        insert testAccounts;

        for (Account acc : testAccounts) {
            acc.Industry = 'Technology';
        }

        Test.startTest();
        update testAccounts;
        Test.stopTest();

        Integer queuedJobs = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(1, queuedJobs, 'A batch job should have been queued for processing');
    }
}
