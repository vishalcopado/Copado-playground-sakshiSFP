/**
 * Read-only service methods for Project__c records.
 */
public with sharing class ProjectService {

    private static final Set<String> OPEN_STATUSES = new Set<String>{ 'Planning', 'In Progress' };

    /**
     * Returns open projects for an account, soonest target date first.
     */
    public static List<Project__c> getOpenProjectsForAccount(Id accountId) {
        if (accountId == null) {
            return new List<Project__c>();
        }
        return [
            SELECT Id, Name, Status__c, Start_Date__c, Target_Date__c, Budget__c
            FROM Project__c
            WHERE Account__c = :accountId
              AND Status__c IN :OPEN_STATUSES
            ORDER BY Target_Date__c ASC NULLS LAST
        ];
    }

    /**
     * Returns the sum of budgets across all projects for an account.
     */
    public static Decimal getTotalBudgetForAccount(Id accountId) {
        if (accountId == null) {
            return 0;
        }
        Decimal total = 0;
        for (AggregateResult result : [
            SELECT SUM(Budget__c) budgetTotal
            FROM Project__c
            WHERE Account__c = :accountId
        ]) {
            Decimal sum = (Decimal) result.get('budgetTotal');
            if (sum != null) {
                total = sum;
            }
        }
        return total;
    }
}
