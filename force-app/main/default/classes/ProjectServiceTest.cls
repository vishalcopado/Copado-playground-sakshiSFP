@isTest
private class ProjectServiceTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Acme Test Account');
        insert acc;

        insert new List<Project__c>{
            new Project__c(Account__c = acc.Id, Status__c = 'Planning', Budget__c = 5000, Target_Date__c = Date.today().addDays(60)),
            new Project__c(Account__c = acc.Id, Status__c = 'In Progress', Budget__c = 2500, Target_Date__c = Date.today().addDays(30)),
            new Project__c(Account__c = acc.Id, Status__c = 'Completed', Budget__c = 1000, Target_Date__c = Date.today().addDays(-5))
        };
    }

    @isTest
    static void testGetOpenProjectsExcludesClosedAndSortsByTargetDate() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        List<Project__c> projects = ProjectService.getOpenProjectsForAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(2, projects.size(), 'Completed projects should be excluded');
        System.assertEquals('In Progress', projects[0].Status__c, 'Earliest target date should come first');
        System.assertEquals('Planning', projects[1].Status__c);
    }

    @isTest
    static void testGetOpenProjectsWithNullAccountReturnsEmpty() {
        Test.startTest();
        List<Project__c> projects = ProjectService.getOpenProjectsForAccount(null);
        Test.stopTest();

        System.assertEquals(0, projects.size(), 'Null account should return no projects');
    }

    @isTest
    static void testGetTotalBudgetForAccount() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Decimal total = ProjectService.getTotalBudgetForAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(8500, total, 'Budget total should include all projects for the account');
    }

    @isTest
    static void testGetTotalBudgetWithNullAccountReturnsZero() {
        Test.startTest();
        Decimal total = ProjectService.getTotalBudgetForAccount(null);
        Test.stopTest();

        System.assertEquals(0, total, 'Null account should return zero');
    }
}
