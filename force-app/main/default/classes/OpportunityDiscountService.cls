/**
 * Discount approval thresholds for Opportunity.
 * A discount of 15% or less needs no approval. Above 15%, the owner's
 * manager must approve before Closed Won. Above 30%, the Sales Director
 * must approve as well.
 */
public with sharing class OpportunityDiscountService {

    public static final Decimal MANAGER_APPROVAL_THRESHOLD = 15;
    public static final Decimal SALES_DIRECTOR_APPROVAL_THRESHOLD = 30;

    public static Boolean requiresManagerApproval(Decimal discountPercent) {
        return discountPercent != null && discountPercent > MANAGER_APPROVAL_THRESHOLD;
    }

    public static Boolean requiresSalesDirectorApproval(Decimal discountPercent) {
        return discountPercent != null && discountPercent > SALES_DIRECTOR_APPROVAL_THRESHOLD;
    }
}
