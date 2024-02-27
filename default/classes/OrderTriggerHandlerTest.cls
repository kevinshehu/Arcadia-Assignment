@isTest
public with sharing class OrderTriggerHandlerTest {
    @TestSetup
    static void setup() {
        // Create and insert an Account
        Account testAccount = new Account(Name = 'TestAccount123');
        insert testAccount;

        // Create and insert a Contract
        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            StartDate = System.today(),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert testContract;

        // Update the Contract to 'Active' status
        testContract.Status = 'Active';
        update testContract;

        // Create and insert a Product
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Get the standard Pricebook ID and make it active
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId, IsActive = true);
        update standardPricebook;

        // Create and insert a PricebookEntry for the standard Pricebook
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert standardPricebookEntry;

        // Create and insert an Order
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            ContractId = testContract.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = standardPricebook.Id
        );
        insert testOrder;

        // Create and insert an OrderItem
        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = standardPricebookEntry.Id,
            Quantity = 1,
            UnitPrice = standardPricebookEntry.UnitPrice
        );
        insert testOrderItem;
    }

    @isTest 
    static void testOrderStatusUpdate() {
        Order testOrder = [SELECT Id, Status, CustomerAuthorizedDate FROM Order LIMIT 1];

        testOrder.CustomerAuthorizedDate = Date.today();

        Test.startTest();
        update testOrder;
        Test.stopTest();

        testOrder = [SELECT Status FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals('Shipped', testOrder.Status);
    }
}