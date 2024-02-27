public with sharing class OrderTriggerHandler extends TriggerHandler {
    private Boolean isExecuting;
    private Map<Id, Order> oldMap;
    private Map<Id, Order> newMap;
    private List<Order> newTrigger;
    private List<Order> oldTrigger;

    public OrderTriggerHandler() {
        this.isExecuting = Trigger.isExecuting;
        this.oldMap = (Map<Id, Order>) Trigger.oldMap;
        this.newMap = (Map<Id, Order>) Trigger.newMap;
        this.oldTrigger = (List<Order>) Trigger.old;
        this.newTrigger = (List<Order>) Trigger.new;
    }

    public override void beforeInsert() {
    }

    public override void beforeUpdate() {
        updateOrderStatus();
    }

    private void updateOrderStatus() {
        try {
            for (Order newOrder : newTrigger) {
                Order oldOrder = oldMap.get(newOrder.Id);
    
                if (newOrder.CustomerAuthorizedDate != null && (newOrder.CustomerAuthorizedDate != oldOrder.CustomerAuthorizedDate)) 
                {
                    newOrder.Status = 'Shipped';
                }
            }
        } catch (Exception e) {
            Util.logException(e);
        }
    }
}
