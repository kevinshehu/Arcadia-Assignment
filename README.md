# Arcadia-Assignment

Assignment #1


AC 1: Please create the product and its associated options

I created the products and associated all of them with the Vacation Product:
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/0555b545-9ad5-4e08-b86e-660816c9b394)
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/a2e2a5c5-3787-4438-97f3-14fb5422b3a0)

The price of the daily breakfast is included in the vacation package, ensuring that no additional cost will be added for this amenity, as it is bundled with the overall vacation pricing.
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/e4e338a4-32aa-49d0-bcf3-3e5dcafb4efc)




AC 1/a: If Airfare is purchased, require either the purchase of the rental car service or an airport transfer.
I developed three components to meet the specified requirement: QuoteLineItemTrigger, QuoteLineItemTriggerHandler, and QuoteLineItemTriggerHandlerTest. Within the QuoteLineItemTriggerHandler, I implemented logic in the after-insert state. This logic is designed to assess the quantity of 'Airfare' and compare it against the combined quantities of 'RentalCar' and 'AirportTransfer'. Should the quantity of 'Airfare' exceed this combined total, the following error message will be triggered:
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/382d5e6b-9898-44da-a3b1-05b490a5222e)



AC 2: Require a minimum of two nights' accommodation
I developed the Accommodation_Check validation rule on the Quote Line object:

![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/b208e6aa-2bf2-4d6d-9d63-00cf5b054bff)



AC 3: Require Billing Address when creating a quote
I made the Billing Address a required field.



AC 4: Build a quote that includes: 10 days accommodation, Round trip airfare, Massage
Record URL: https://urjanet--assign1.sandbox.lightning.force.com/lightning/r/SBQQ__Quote__c/a4ZO3000000BY1ZMAW/view
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/b9981d65-d57a-43d5-8c6c-8f8ad8e409b5)



AC 5/a: You need to be able to track check-in and check-out dates. At a minimum, you need the Name, check-in date, check-out date, and confirmation number.
I enhanced the Quote object by adding four new fields. These include two date fields for check-in and check-out, each accompanied by their respective validation rules. Additionally, a lookup field to Contact has been introduced to accurately identify the customer. Furthermore, I've implemented an auto-number field for the confirmation number, which follows the format CN-{YYYYMMDD}-{0000}.



AC 5/b: Confirmation number should be set up so that it cannot be duplicated.
It won't since the field is auto-number, read-only.



AC 5/c: Send a welcome message to the guest at check-in that provides links to nearby attractions.
I developed a scheduled trigger flow named "Customer Notificator Scheduler," set to run daily around 11 AM. This flow is tasked with identifying contacts due for check-in on the same day and sending them a pre-defined email. However, it's important to note that due to the limitations of the email action in flows, only up to five customers can be notified at a time. To address this constraint, we have the option to implement the email-sending functionality using Apex, which would allow for greater scalability in customer notifications.
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/b196c611-e995-4d67-b3fd-7ed7ee544e81)


AC 6: Create an email that is sent upon check-out that thanks the person for their stay and invites them to return.
Within the same flow, "Customer Notificator Scheduler," I have also incorporated a feature to send a farewell greeting to customers on their checkout day.
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/8d05ab35-2f3b-4919-ae27-54017833a87d)



AC 7: Build a lightning app that highlights the following on the home page a. Upcoming confirmed check-ins b. Relevant News c. Recent records viewed
In response to the requirements outlined, I created a Lightning app complete with a dashboard and a report. This app prominently displays on its home page the following elements: Upcoming confirmed check-ins. Recently viewed records.
![image](https://github.com/kevinshehu/Arcadia-Assignment/assets/57314395/6216c551-1bd5-4f85-9722-3fa4aaf12254)




Assignment #2

AC 1: Trigger Development
I created OrderTrigger, OrderTriggerHandler, and OrderTriggerHandlerTest for the trigger development task. In OrderTriggerHandler, I implemented logic in the beforeUpdate method to automatically update the 'Order Status' to 'Shipped' when the 'Customer Authorized Date' is set, ensuring bulk update handling and adherence to best practices.



AC 2: Batch Apex
I created a Batch Apex class, OpportunityBatchUpdate, and an AccountTriggerHandler to address the requirement of updating 'Open' opportunities when an account's 'Industry' field changes to 'Technology'. The trigger, AccountTrigger, on the Account object, invokes AccountTriggerHandler which in turn calls the batch class if the conditions are met. The batch class updates the 'Close Date' of these opportunities to the end of the current quarter. I also wrote test classes, OpportunityBatchUpdateTest and AccountTriggerHandlerTest, to ensure the functionality works as expected and adheres to Salesforce best practices.



AC 3: Apex Test Class
As mentioned above I developed test classes for each apex class created.



AC 4: Exception Handling
I implemented exception handling in the trigger and Batch Apex class by creating a utility class, Util. This class contains a method logException that logs exceptions to a custom object LID__Error_Log__c. The log records the exception message, line number, and stack trace for effective debugging. Additionally, I developed a test class, UtilTest, to validate the functionality of the exception logging, ensuring that it captures and logs error details correctly in various scenarios.



