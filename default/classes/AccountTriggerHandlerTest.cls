@isTest
public with sharing class AccountTriggerHandlerTest {
    @isTest static void testBeforeUpdate() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Banking');
        insert testAccount;

        testAccount.Industry = 'Technology';
        Test.startTest();
        update testAccount;
        Test.stopTest();

        Integer queuedJobs = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(1, queuedJobs, 'A batch job should have been queued for processing');
    }
}