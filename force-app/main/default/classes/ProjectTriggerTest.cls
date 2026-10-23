@isTest
private class ProjectTriggerTest {

    @testSetup
    static void setupData() {
        insert new Account(Name = 'Trigger Test Account');
    }

    @isTest
    static void testDefaultStatusAppliedOnInsert() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Project__c proj = new Project__c(Account__c = acc.Id);

        Test.startTest();
        insert proj;
        Test.stopTest();

        Project__c saved = [SELECT Status__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals(Label.Project_Default_Status, saved.Status__c, 'Blank status should default');
    }

    @isTest
    static void testValidDatesAndBudgetAreAccepted() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Project__c proj = new Project__c(
            Account__c = acc.Id,
            Status__c = 'In Progress',
            Start_Date__c = Date.today(),
            Target_Date__c = Date.today().addDays(30),
            Budget__c = 10000
        );

        Test.startTest();
        insert proj;
        proj.Budget__c = 12000;
        update proj;
        Test.stopTest();

        Project__c saved = [SELECT Budget__c FROM Project__c WHERE Id = :proj.Id];
        System.assertEquals(12000, saved.Budget__c, 'Valid update should be saved');
    }

    @isTest
    static void testTargetDateBeforeStartIsRejected() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Project__c proj = new Project__c(
            Account__c = acc.Id,
            Start_Date__c = Date.today(),
            Target_Date__c = Date.today().addDays(-1)
        );

        Test.startTest();
        try {
            insert proj;
            System.assert(false, 'Expected a DmlException for target date before start date');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains(Label.Project_Error_Target_Before_Start),
                'Unexpected error message: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testNegativeBudgetIsRejectedOnUpdate() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Project__c proj = new Project__c(Account__c = acc.Id, Budget__c = 500);
        insert proj;

        Test.startTest();
        try {
            proj.Budget__c = -100;
            update proj;
            System.assert(false, 'Expected a DmlException for negative budget');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains(Label.Project_Error_Negative_Budget),
                'Unexpected error message: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
}
