@isTest
public class DuplicateRecordHandlersTest {

    @TestSetup
    static void makeData(){
        Account a = new Account(Name = 'TLDR');
        insert a;
        Contact c = new Contact();
        c.FirstName = 'John';
        c.LastName = 'Smith';
        c.Email = 'john@tldr.com';
        c.AccountId = a.Id;
        insert c;
    }

    static List<Account> setupAccounts(){
        List<Account> accts = new List<Account>();
        for(Integer i = 0; i < 2; i++){
        Account a = new Account();
        a.Name = 'TLDR';
        accts.add(a);
        }
        return accts;
    }

    static List<Contact> setupContacts(List<Account> accts){
        List<Contact> cons = new List<Contact>();
        for(Account a : accts){
            cons.add(setupContact(a.Id));
        }
        return cons;
    }

    static Contact setupContact(Id acctId){
        Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Smith';
            c.Email = 'smith@tldr.com';
            c.AccountId = acctId;
            return c;
    }

    @isTest
    private static void dupeAccountsCreate(){
        DuplicateRule dR = [select id from DuplicateRule where DeveloperName = 'Standard_Account_duplicate_rule' LIMIT 1];
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dR.id);
        insert dupRS;

        test.startTest();
        Account a = new Account();
        a.Name = 'TLDR';
        //insert a;

        Database.DMLOptions insertDML = new Database.DMLOptions();
        insertDML.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr = Database.insert(a, insertDML);

        List<DuplicateRecordItem> drisToInsert = new List<DuplicateRecordItem>();
        for(Account ac : [SELECT Id FROM Account]){
            DuplicateRecordItem dup = new DuplicateRecordItem(DuplicateRecordSetId = dupRS.id, RecordId = ac.id);
            drisToInsert.add(dup);
        }
        insert drisToInsert;
        test.stopTest();

        List<DuplicateRecordSet> drsList = [SELECT Id, Object_Type__c FROM DuplicateRecordSet];
        System.assertEquals(1, drsList.size(), 'Should be one DuplicateRecordSet');
        
        List<DuplicateRecordItem> driList = [SELECT Id, Object_Type__c, Account__c FROM DuplicateRecordItem];
  	    update driList;

        List<Account> master = [SELECT Id FROM Account WHERE Id = :a.Id];
        List<Account> dupes = [SELECT Id FROM Account WHERE Id != :a.Id];
        Database.MergeResult[] results = Database.merge(master[0], dupes, false);
        //System.assertEquals(0, [SELECT Count() FROM DuplicateRecordSet]);
    }

    @isTest
    private static void dupeAccountsMerge(){
        DuplicateRule dR = [select id from DuplicateRule where DeveloperName = 'Standard_Account_duplicate_rule' LIMIT 1];
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dR.id);
        insert dupRS;

        test.startTest();
        Account a = new Account();
        a.Name = 'TLDR';
        //insert a;

        Database.DMLOptions insertDML = new Database.DMLOptions();
        insertDML.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr = Database.insert(a, insertDML);

        List<DuplicateRecordItem> drisToInsert = new List<DuplicateRecordItem>();
        for(Account ac : [SELECT Id FROM Account]){
            DuplicateRecordItem dup = new DuplicateRecordItem(DuplicateRecordSetId = dupRS.id, RecordId = ac.id);
            drisToInsert.add(dup);
        }
        insert drisToInsert;

        List<DuplicateRecordSet> drsList = [SELECT Id, Object_Type__c FROM DuplicateRecordSet];
        System.assertEquals(1, drsList.size(), 'Should be one DuplicateRecordSet');
        
        List<DuplicateRecordItem> driList = [SELECT Id, Object_Type__c, Account__c FROM DuplicateRecordItem];
        List<Account> master = [SELECT Id FROM Account WHERE Id = :a.Id];
        List<Account> dupes = [SELECT Id FROM Account WHERE Id != :a.Id];
        Database.MergeResult[] results = Database.merge(master[0], dupes, false);
        test.stopTest();

        System.assertEquals(0, [SELECT Count() FROM DuplicateRecordSet], 'DuplicateRecordSet not deleted');
    }


    /* CONTACTS **************************** */

    @isTest
    private static void dupeContactsCreate(){
        DuplicateRule dR = [select id from DuplicateRule where DeveloperName = 'Standard_Contact_duplicate_rule' LIMIT 1];
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dR.id);
        insert dupRS;

        test.startTest();
        Account a = [SELECT Id FROM Account][0];
        Contact c = setupContact(a.Id);

        Database.DMLOptions insertDML = new Database.DMLOptions();
        insertDML.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr = Database.insert(c, insertDML);

        List<DuplicateRecordItem> drisToInsert = new List<DuplicateRecordItem>();
        for(Contact cc : [SELECT Id FROM Contact]){
            DuplicateRecordItem dup = new DuplicateRecordItem(DuplicateRecordSetId = dupRS.id, RecordId = cc.id);
            drisToInsert.add(dup);
        }
        insert drisToInsert;
        test.stopTest();

        List<DuplicateRecordSet> drsList = [SELECT Id, Object_Type__c FROM DuplicateRecordSet];
        System.assertEquals(1, drsList.size(), 'Should be one DuplicateRecordSet');

        List<DuplicateRecordItem> driList = [SELECT Id, Object_Type__c, Contact__c FROM DuplicateRecordItem];
        List<Contact> master = [SELECT Id FROM Contact WHERE Id = :c.Id];
        List<Contact> dupes = [SELECT Id FROM Contact WHERE Id != :c.Id];
        Database.MergeResult[] results = Database.merge(master[0], dupes, false);
        //System.assertEquals(0, [SELECT Count() FROM DuplicateRecordSet]);
    }

    @isTest
    private static void dupeContactsMerge(){
        DuplicateRule dR = [select id from DuplicateRule where DeveloperName = 'Standard_Contact_duplicate_rule' LIMIT 1];
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dR.id);
        insert dupRS;

        test.startTest();
        Account a = [SELECT Id FROM Account][0];
        Contact c = setupContact(a.Id);

        Database.DMLOptions insertDML = new Database.DMLOptions();
        insertDML.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr = Database.insert(c, insertDML);

        List<DuplicateRecordItem> drisToInsert = new List<DuplicateRecordItem>();
        for(Contact cc : [SELECT Id FROM Contact]){
            DuplicateRecordItem dup = new DuplicateRecordItem(DuplicateRecordSetId = dupRS.id, RecordId = cc.id);
            drisToInsert.add(dup);
        }
        insert drisToInsert;

        List<DuplicateRecordSet> drsList = [SELECT Id, Object_Type__c FROM DuplicateRecordSet];
        System.assertEquals(1, drsList.size(), 'Should be one DuplicateRecordSet');
        //System.assertEquals('Contact', drsList[0].Object_Type__c); // can't know this because we are creating it manually

        List<DuplicateRecordItem> driList = [SELECT Id, Object_Type__c, Contact__c FROM DuplicateRecordItem];
        List<Contact> master = [SELECT Id FROM Contact WHERE Id = :c.Id];
        List<Contact> dupes = [SELECT Id FROM Contact WHERE Id != :c.Id];
        Database.MergeResult[] results = Database.merge(master[0], dupes, false);
        test.stopTest();

        System.assertEquals(0, [SELECT Count() FROM DuplicateRecordSet], 'DuplicateRecordSet not deleted');
    }
}
