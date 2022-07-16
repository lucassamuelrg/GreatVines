public with sharing class AccountDomain {
    private static AccountDomain instance = null;
    private final SObjectPermission accountPermission;
    
    public static AccountDomain getInstance() {
        if(instance == null){
            instance = new AccountDomain();
        }
        return instance;
    }

    private AccountDomain() {
        this.accountPermission = new SObjectPermission('Account');
    }

    public void parentAccountCriationInsert(List<Account> newList) {
        List<Account> parentAccountToInsert = new List<Account>();
        Boolean parentIdEditPermission = accountPermission.validateEditFieldPermission('ParentId');
        for (Account accNew : newList) {
            if (validateParentAccountCriationWithoutParent(accNew, parentIdEditPermission)) {
                parentAccountToInsert.add(createParenteAccount(accNew));
            }
        }
        insert parentAccountToInsert;
    }
    
    private @TestVisible
    Boolean validateParentAccountCriationWithoutParent(Account accNew, Boolean parentIdEditPermission) {
        return String.isBlank(accNew.ParentId) && accNew.Status__c == Label.AccountStatusCold && this.accountPermission.create && parentIdEditPermission;
    }

    public void parentAccountCriationUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        List<Account> parentAccountToInsert = new List<Account>();
        Boolean parentIdEditPermission = accountPermission.validateEditFieldPermission('ParentId');
        for (Account accNew : newList) {
            Account accOld = oldMap.get(accNew.Id);
            if (validateParentAccountCriation(accNew, accOld, parentIdEditPermission)) {
                parentAccountToInsert.add(createParenteAccount(accNew));
            }
        }
        insert parentAccountToInsert;
    }

    private @TestVisible
    Boolean validateParentAccountCriation(Account accNew, Account accOld, Boolean parentIdEditPermission) {
        return accNew.Status__c == Label.AccountStatusCold && accNew.Status__c != accOld.Status__c && this.accountPermission.create && parentIdEditPermission;
    }

    private @TestVisible
    Account createParenteAccount(Account accNew) {
        return new Account(Name = accNew.Name, ParentId = accNew.Id, Status__c = Label.AccountStatusCold);
    }
}
