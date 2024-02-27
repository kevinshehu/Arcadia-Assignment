public with sharing class AccountTriggerHandler extends TriggerHandler  {
    private Boolean isExecuting;
    private Map<Id, Account> oldMap;
    private Map<Id, Account> newMap;
    private List<Account> newTrigger;
    private List<Account> oldTrigger;

    public AccountTriggerHandler() {
        this.isExecuting = Trigger.isExecuting;
        this.oldMap = (Map<Id, Account>) Trigger.oldMap;
        this.newMap = (Map<Id, Account>) Trigger.newMap;
        this.oldTrigger = (List<Account>) Trigger.old;
        this.newTrigger = (List<Account>) Trigger.new;
    }

    public override void beforeInsert() {
    }

    public override void beforeUpdate() {
        updateAccountStatus();
    }

    private void updateAccountStatus() {
        try {
            List<Account> accountsToUpdate = new List<Account>();

            for (Account newAcc : newTrigger) {
                Account oldAcc = oldMap.get(newAcc.Id);
                if (newAcc.Industry == 'Technology' && (oldAcc == null || oldAcc.Industry != 'Technology')) {
                    accountsToUpdate.add(newAcc);
                }
            }
    
            if (!accountsToUpdate.isEmpty()) {
                Database.executeBatch(new OpportunityBatchUpdate(accountsToUpdate));
            }
        } catch (Exception e) {
            Util.logException(e);
        }
    }
}
