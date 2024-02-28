@isTest
public with sharing class QuoteLineItemTriggerHandlerTest {
    @TestSetup
    static void setup() {
        Product2 airfareProduct = new Product2(Name = 'Airfare', ProductCode = 'Airfare', IsActive = true);
        insert airfareProduct;
        Product2 rentalCarProduct = new Product2(Name = 'RentalCar', ProductCode = 'RentalCar', IsActive = true);
        insert rentalCarProduct;
        Product2 airportTransferProduct = new Product2(Name = 'AirportTransfer', ProductCode = 'AirportTransfer', IsActive = true);
        insert airportTransferProduct;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId, IsActive = true);
        update standardPricebook;

        PricebookEntry airfarePBE = new PricebookEntry(Pricebook2Id = standardPricebook.Id, Product2Id = airfareProduct.Id, UnitPrice = 500.00, IsActive = true);
        insert airfarePBE;
        PricebookEntry rentalCarPBE = new PricebookEntry(Pricebook2Id = standardPricebook.Id, Product2Id = rentalCarProduct.Id, UnitPrice = 300.00, IsActive = true);
        insert rentalCarPBE;
        PricebookEntry airportTransferPBE = new PricebookEntry(Pricebook2Id = standardPricebook.Id, Product2Id = airportTransferProduct.Id, UnitPrice = 200.00, IsActive = true);
        insert airportTransferPBE;

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity', AccountId = testAccount.Id, StageName = '1-Qualification', CloseDate = System.today().addDays(30));
        insert testOpportunity;

        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;

        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(
            SBQQ__Opportunity2__c = testOpportunity.Id, 
            Contact__c = testContact.Id,
            Billing_Address__c = '123 Test Street, Test City, TC',
            Check_in__c = System.today(), 
            Check_out__c = System.today().addDays(7)
        );
        insert testQuote;

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = testQuote.Id, SBQQ__Product__c = airfareProduct.Id, SBQQ__Quantity__c = 2));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = testQuote.Id, SBQQ__Product__c = rentalCarProduct.Id, SBQQ__Quantity__c = 1));
        quoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = testQuote.Id, SBQQ__Product__c = airportTransferProduct.Id, SBQQ__Quantity__c = 1));
        insert quoteLines;
    }

    @isTest
    static void testEnforceAirfareRules() {
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT SBQQ__Product__c, SBQQ__Quote__c, SBQQ__Quantity__c FROM SBQQ__QuoteLine__c];
        for(SBQQ__QuoteLine__c ql : quoteLines) {
            if(ql.SBQQ__Product__c == [SELECT Id FROM Product2 WHERE ProductCode = 'Airfare'].Id) {
                ql.SBQQ__Quantity__c = 3;
            }
        }
        Test.startTest();
            try {
                update quoteLines;
                System.assert(false, 'Error should be thrown');
            } catch (Exception e) {
                System.assert(true, 'Error should be thrown');
            }
        Test.stopTest();
    }
}