public with sharing class QuoteLineItemTriggerHandler extends TriggerHandler {
    private Boolean isExecuting;
    private Map<Id, SBQQ__QuoteLine__c> oldMap;
    private Map<Id, SBQQ__QuoteLine__c> newMap;
    private List<SBQQ__QuoteLine__c> newTrigger;
    private List<SBQQ__QuoteLine__c> oldTrigger;

    public QuoteLineItemTriggerHandler() {
        this.isExecuting = Trigger.isExecuting;
        this.oldMap = (Map<Id, SBQQ__QuoteLine__c>) Trigger.oldMap;
        this.newMap = (Map<Id, SBQQ__QuoteLine__c>) Trigger.newMap;
        this.oldTrigger = (List<SBQQ__QuoteLine__c>) Trigger.old;
        this.newTrigger = (List<SBQQ__QuoteLine__c>) Trigger.new;
    }

    public override void beforeInsert() {
        enforceAirfareRules(newTrigger);
    }

    public override void beforeUpdate() {
        enforceAirfareRules(newTrigger);
    }

    private void enforceAirfareRules(List<SBQQ__QuoteLine__c> quoteLineItems) {
        Set<Id> quoteIds = new Set<Id>();
        for (SBQQ__QuoteLine__c item : quoteLineItems) {
            quoteIds.add(item.SBQQ__Quote__c);
        }
    
        Map<Id, Decimal> airfareQuantities = new Map<Id, Decimal>();
        Map<Id, Decimal> rentalCarQuantities = new Map<Id, Decimal>();
        Map<Id, Decimal> airportTransferQuantities = new Map<Id, Decimal>();
    
        for (SBQQ__QuoteLine__c item : [SELECT Id, SBQQ__Product__r.ProductCode, SBQQ__Quote__c, SBQQ__Quantity__c 
                                        FROM SBQQ__QuoteLine__c 
                                        WHERE SBQQ__Quote__c IN :quoteIds]) {
            if (item.SBQQ__Product__r.ProductCode == 'Airfare') {
                airfareQuantities.put(item.SBQQ__Quote__c, item.SBQQ__Quantity__c);
            }
            if (item.SBQQ__Product__r.ProductCode == 'RentalCar') {
                rentalCarQuantities.put(item.SBQQ__Quote__c, (rentalCarQuantities.get(item.SBQQ__Quote__c) != null ? rentalCarQuantities.get(item.SBQQ__Quote__c) : 0) + item.SBQQ__Quantity__c);
            }
            if (item.SBQQ__Product__r.ProductCode == 'AirportTransfer') {
                airportTransferQuantities.put(item.SBQQ__Quote__c, (airportTransferQuantities.get(item.SBQQ__Quote__c) != null ? airportTransferQuantities.get(item.SBQQ__Quote__c) : 0) + item.SBQQ__Quantity__c);
            }
        }
    
        for (SBQQ__QuoteLine__c item : quoteLineItems) {
            Id quoteId = item.SBQQ__Quote__c;
            Decimal airfareQuantity = airfareQuantities.containsKey(quoteId) ? airfareQuantities.get(quoteId) : 0;
            Decimal rentalCarQuantity = rentalCarQuantities.containsKey(quoteId) ? rentalCarQuantities.get(quoteId) : 0;
            Decimal airportTransferQuantity = airportTransferQuantities.containsKey(quoteId) ? airportTransferQuantities.get(quoteId) : 0;
            Decimal totalAdditionalServices = rentalCarQuantity + airportTransferQuantity;
    
            if (airfareQuantity > 0 && airfareQuantity > totalAdditionalServices) {
                item.addError('Airfare purchase requires an additional selection of either \'Rental Car Service\' or \'Airport Transfer');
            }
        }
    }
}
