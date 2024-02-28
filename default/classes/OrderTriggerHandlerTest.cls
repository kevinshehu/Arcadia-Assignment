@isTest
public with sharing class OrderTriggerHandlerTest {

    @TestSetup
    static void setup() {
        Account testAccount = new Account(Name = 'TestAccount123');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            StartDate = System.today(),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert testContract;

        testContract.Status = 'Active';
        update testContract;

        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId, IsActive = true);
        update standardPricebook;

        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert standardPricebookEntry;

        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 10; i++) {
            testOrders.add(new Order(
                AccountId = testAccount.Id,
                ContractId = testContract.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPricebook.Id
            ));
        }
        insert testOrders;

        List<OrderItem> testOrderItems = new List<OrderItem>();
        for (Order ord : testOrders) {
            testOrderItems.add(new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = standardPricebookEntry.Id,
                Quantity = 1,
                UnitPrice = standardPricebookEntry.UnitPrice
            ));
        }
        insert testOrderItems;
    }

    @isTest 
    static void testOrderStatusUpdate() {
        List<Order> testOrders = [SELECT Id, Status, CustomerAuthorizedDate FROM Order];

        for (Order ord : testOrders) {
            ord.CustomerAuthorizedDate = Date.today();
        }

        Test.startTest();
        update testOrders;
        Test.stopTest();

        testOrders = [SELECT Status FROM Order WHERE Id IN :testOrders];

        for (Order ord : testOrders) {
            System.assertEquals('Shipped', ord.Status, 'The Order status should be updated to Shipped.');
        }
    }
}
