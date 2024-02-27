@isTest
public with sharing class UtilTest {
    @isTest static void testLogException() {
        try {
            Integer testDivideByZero = 1 / 0;
        } catch (Exception e) {
            Util.logException(e);
        }

        LID__Error_Log__c[] errorLogs = [SELECT LID__Message__c, LID__Line_Number__c, LID__Stack_Trace__c FROM LID__Error_Log__c];
        System.assertEquals(1, errorLogs.size(), 'One error log should be created.');

        LID__Error_Log__c logRecord = errorLogs[0];

        System.assertNotEquals(null, logRecord.LID__Message__c, 'Error message should not be null.');
        System.assertNotEquals(null, logRecord.LID__Line_Number__c, 'Line number should not be null.');
        System.assertNotEquals(null, logRecord.LID__Stack_Trace__c, 'Stack trace should not be null.');
    }
}