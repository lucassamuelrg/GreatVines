public with sharing class AccountTriggerHandler extends TriggerHandler {
    
    // public override void beforeInsert () {}
    
    // public override void beforeUpdate () {}
    
    //public override void beforeDelete () {}
    
    public override void afterInsert () {
        AccountDomain.getInstance().parentAccountCriationInsert((List<Account>) Trigger.new);
    }
    
    public override void afterUpdate () {
        AccountDomain.getInstance().parentAccountCriationUpdate((List<Account>) Trigger.new, (Map<Id, Account>) Trigger.oldMap);
    }
    
    // public override void afterDelete () {}
    
    //public override void afterUndelete () {}
}