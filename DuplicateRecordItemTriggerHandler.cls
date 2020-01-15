public without sharing class DuplicateRecordItemTriggerHandler {

        public static void handleTrigger(List<DuplicateRecordItem> newRecords, List<DuplicateRecordItem> oldRecords, Map<Id, DuplicateRecordItem> newRecordsMap, Map<Id, DuplicateRecordItem> oldRecordsMap, System.TriggerOperation triggerEvent) {
    //System.debug('IN DUPLICATE RECORD ITEM TRIGGER HANDLER');
        switch on triggerEvent {

            when BEFORE_INSERT {
                fillFields(newRecords);
            }

            when AFTER_INSERT {
                updateDuplicateRecordSet(newRecords);
            }

            when BEFORE_UPDATE {
                fillFields(newRecords);
            }

            when AFTER_UPDATE {
                updateDuplicateRecordSet(newRecords);
            }
            // Not needed because roll-up triggers DRS update
            //when BEFORE_DELETE {}
            //when AFTER_DELETE {}

            // Why on earth would you ever need this???
            //when AFTER_UNDELETE {}
        }
    }

    private static void fillFields(List<DuplicateRecordItem> newRecords){
        Set<Id> recIDs = new Set<Id>();
        for(DuplicateRecordItem dri : newRecords){
            recIDs.add(dri.RecordId);
        }
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Name, CreatedBy.Name, CreatedDate FROM Account WHERE Id IN :recIDs]);
        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Name, AccountId, CreatedBy.Name, CreatedDate FROM Contact WHERE Id IN :recIDs]);
        for(DuplicateRecordItem dri : newRecords){
            if(dri.RecordId.getSobjectType() == Schema.Account.SObjectType){
                System.debug('DUPLICATE ACCOUNT');
                dri.Object_Type__c = 'Account';
                if(accounts.containsKey(dri.RecordId)){
                    Account a = accounts.get(dri.RecordId);
                    dri.Account__c = a.Id;
                    dri.Created_By__c = a.CreatedBy.Name;
                    dri.Created_Date__c = a.CreatedDate;
                }
            }
            else if(dri.RecordId.getSobjectType() == Schema.Contact.SObjectType){
                dri.Object_Type__c = 'Contact';
                System.debug('DUPLICATE CONTACT');
                if(contacts.containsKey(dri.RecordId)){
                    dri.Account__c = contacts.get(dri.RecordId).AccountId;
                    Contact c = contacts.get(dri.RecordId);
                    dri.Contact__c = c.Id;
                    dri.Created_By__c = c.CreatedBy.Name;
                    dri.Created_Date__c = c.CreatedDate;
                }
            }
            else {
                // We can use some super-cool code to get the object type from any ID
                dri.Object_Type__c = dri.RecordId.getSObjectType().getDescribe().getName();
            }
        }
    }

    private static void updateDuplicateRecordSet(List<DuplicateRecordItem> newRecords){
        Map<Id, DuplicateRecordSet> toUpdate = new Map<Id, DuplicateRecordSet>();
        for(DuplicateRecordItem dri : newRecords){
            String sObjectName = dri.RecordId.getSObjectType().getDescribe().getName();
            DuplicateRecordSet drs = new DuplicateRecordSet(Id = dri.DuplicateRecordSetId);
            drs.Object_Type__c = sObjectName;
            toUpdate.put(dri.DuplicateRecordSetId, drs);
        }
        update toUpdate.values();
    }

}
