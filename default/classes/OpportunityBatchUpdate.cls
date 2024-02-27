global class OpportunityBatchUpdate implements Database.Batchable<sObject> {
    private List<Account> accounts;

    public OpportunityBatchUpdate(List<Account> accountsToUpdate) {
        this.accounts = accountsToUpdate;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, CloseDate FROM Opportunity WHERE AccountId IN :accounts AND StageName = \'Open\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        try {
            Period currentQuarter = [SELECT EndDate FROM Period WHERE Type = 'Quarter' AND StartDate = THIS_FISCAL_QUARTER LIMIT 1];
            Date endOfQuarter = currentQuarter.EndDate;

            for (Opportunity opp : scope) {
                opp.CloseDate = endOfQuarter;
            }

            update scope;
        } catch (Exception e) {
            Util.logException(e);
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}
