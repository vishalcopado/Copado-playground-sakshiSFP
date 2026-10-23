trigger ProjectTrigger on Project__c (before insert, before update) {
    ProjectTriggerHandler handler = new ProjectTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            handler.beforeUpdate(Trigger.new);
        }
    }
}
