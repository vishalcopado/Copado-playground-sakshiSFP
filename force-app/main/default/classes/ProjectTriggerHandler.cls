/**
 * Business logic for Project__c trigger events.
 */
public with sharing class ProjectTriggerHandler {

    public void beforeInsert(List<Project__c> newProjects) {
        applyDefaults(newProjects);
        validate(newProjects);
    }

    public void beforeUpdate(List<Project__c> newProjects) {
        validate(newProjects);
    }

    private void applyDefaults(List<Project__c> projects) {
        for (Project__c proj : projects) {
            if (String.isBlank(proj.Status__c)) {
                proj.Status__c = Label.Project_Default_Status;
            }
        }
    }

    private void validate(List<Project__c> projects) {
        for (Project__c proj : projects) {
            if (proj.Start_Date__c != null && proj.Target_Date__c != null
                    && proj.Target_Date__c < proj.Start_Date__c) {
                proj.Target_Date__c.addError(Label.Project_Error_Target_Before_Start);
            }
            if (proj.Budget__c != null && proj.Budget__c < 0) {
                proj.Budget__c.addError(Label.Project_Error_Negative_Budget);
            }
        }
    }
}
