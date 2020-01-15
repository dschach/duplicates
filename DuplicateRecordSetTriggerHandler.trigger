public without sharing class DuplicateRecordSetTriggerHandler {
    public static void handleTrigger(List<DuplicateRecordSet> newRecords, List<DuplicateRecordSet> oldRecords, Map<Id, DuplicateRecordSet> newRecordsMap, Map<Id, DuplicateRecordSet> oldRecordsMap, System.TriggerOperation triggerEvent) {
    //System.debug('IN DUPLICATE RECORD SET TRIGGER HANDLER');
        switch on triggerEvent {

            //when BEFORE_INSERT {}
            //when AFTER_INSERT {}
            //when BEFORE_UPDATE {}
            // NOT listed in trigger. To use this, update trigger contexts.
            when AFTER_UPDATE {
                findSingleRecordSets(newRecords);

            }
            //when BEFORE_DELETE {}
            //when AFTER_DELETE {}
            //when AFTER_UNDELETE {}
        }
    }

    private static void findSingleRecordSets(List<DuplicateRecordSet> newRecords){

//      List<DuplicateRecordSet> drsList = [SELECT Id, RecordCount FROM DuplicateRecordSet WHERE Id IN :newRecords];
        Set<Id> toDelete = new Set<Id>();
        for(DuplicateRecordSet drs : newRecords){
            System.debug(drs.Name + ' has this many record: ' + drs.RecordCount);
            if(drs.RecordCount == 1){
                toDelete.add(drs.Id);
            }
        }
        deleteSingleRecordSets(toDelete);
    }

    @future
    private static void deleteSingleRecordSets(Set<Id> candidatesToDelete){
        //if(!candidatesToDelete.isEmpty()){
        //  Database.delete ([SELECT Id FROM DuplicateRecordSet WHERE Id IN :candidatesToDelete], false);
        //}
        System.debug('DELETING ' + [SELECT Count() FROM DuplicateRecordSet WHERE Id IN :candidatesToDelete] + ' SETS');
        delete [SELECT Id FROM DuplicateRecordSet WHERE Id IN :candidatesToDelete];
    }
}
