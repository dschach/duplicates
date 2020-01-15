trigger DuplicateRecordItemTrigger on DuplicateRecordItem (before insert, before update, after insert, after update, after delete) {
  //System.debug('IN DUPLICATE RECORD ITEM TRIGGER');
  DuplicateRecordItemTriggerHandler.handleTrigger(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap, Trigger.operationType);
  
}
