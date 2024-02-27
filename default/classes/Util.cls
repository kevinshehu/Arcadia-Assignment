public without sharing class Util {
    public static void logException(Exception e) {
        LID__Error_Log__c errorLog = new LID__Error_Log__c(
            LID__Message__c = e.getMessage(),
            LID__Line_Number__c = String.valueOf(e.getLineNumber()),
            LID__Stack_Trace__c = e.getStackTraceString()
        );
        insert errorLog;
    }
}