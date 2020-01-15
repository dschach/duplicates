# Salesforce Duplicate Record Handlers
Code for handling Salesforce duplicate record sets and items

Step 1: 
On Duplicate Record Item, create the following fields:
* Contact (Contact__c) - lookup to Contact
* Account (Account__c) - lookup to Account
* Created By (Created_By__c) - Text(255)
* Created At (Created_Date__c) - DateTime
* ObjectType (Object_Type__c) - Text(255)

Step 2: 
On Duplicate Record Set, create the following fields:
* ObjectType (Object_Type__c) - Text(255)

Install the classes and the triggers. No, I haven't made this easy to import. That's because it's for a talk I'm giving and I just want the code handy.

Many thanks to Peter Chittum for his switch code sample: https://developer.salesforce.com/blogs/2018/05/summer18-rethink-trigger-logic-with-apex-switch.html
