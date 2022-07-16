@isTest
public with sharing class AccountDomainTest {
    @TestSetup
    static void setup(){
        Account acc = TestDataFactory.createAccount('Account Test', null);
        Account acc2 = TestDataFactory.createAccount('Account2 Test', null);
        insert new List<Account>{acc, acc2};
    }

    @isTest
    private static void parentAccountCriationInsertTest() {
        List<Account> accList = [SELECT Id, Name, Status__c, ParentId FROM Account];
        accList[0].Status__c = Label.AccountStatusCold;

        accList[1].ParentId = accList[0].Id;

        AccountDomain accDomain = AccountDomain.getInstance();

        Test.startTest();
        accDomain.parentAccountCriationInsert(new List<Account>{accList[1]});
        System.assertEquals(0, [SELECT Id FROM Account WHERE ParentId = :accList[1].Id].size());

        accDomain.parentAccountCriationInsert(new List<Account>{accList[0]});
        System.assertEquals(1, [SELECT Id FROM Account WHERE ParentId = :accList[0].Id].size());
        Test.stopTest();
    }

    @isTest
    private static void validateParentAccountCriationWithoutParentTest() {
        List<Account> accList = [SELECT Id, Name, Status__c, ParentId FROM Account];
        accList[0].Status__c = Label.AccountStatusHot;

        accList[1].ParentId = accList[0].Id;
        
        AccountDomain accDomain = AccountDomain.getInstance();
        
        Test.startTest();
        Boolean accWitHotStatus = accDomain.validateParentAccountCriationWithoutParent(accList[0], true);
        accList[0].Status__c = Label.AccountStatusCold;
        Boolean accWitColdStatus = accDomain.validateParentAccountCriationWithoutParent(accList[0], true);
        Boolean accWithoutParentUpdatePermission = accDomain.validateParentAccountCriationWithoutParent(accList[0], false);
        Boolean accWitParentId = accDomain.validateParentAccountCriationWithoutParent(accList[1], false);
        Test.stopTest();
        System.assert(!accWitHotStatus);
        System.assert(accWitColdStatus);
        System.assert(!accWithoutParentUpdatePermission);
        System.assert(!accWitParentId);
    }

    @isTest
    private static void parentAccountCriationUpdateTest() {
        Account acc = [SELECT Id, Name, Status__c FROM Account LIMIT 1];

        Account accStatusCold = acc.clone(true, false, true, true);
        accStatusCold.Status__c = Label.AccountStatusCold;
        
        Account accStatusHot = acc.clone(true, false, true, true);
        accStatusHot.Status__c = Label.AccountStatusHot;

        AccountDomain accDomain = AccountDomain.getInstance();

        Test.startTest();
        accDomain.parentAccountCriationUpdate(new List<Account>{acc}, new Map<Id, Account>{acc.Id => acc});
        accDomain.parentAccountCriationUpdate(new List<Account>{accStatusHot}, new Map<Id, Account>{acc.Id => acc});
        accDomain.parentAccountCriationUpdate(new List<Account>{accStatusCold}, new Map<Id, Account>{acc.Id => acc});
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Account WHERE ParentId = :acc.Id].size());
    }

    @isTest
    private static void validateParentAccountCriationTest() {
        Account acc = [SELECT Id, Name, Status__c FROM Account LIMIT 1];

        Account accStatusCold = acc.clone(true, false, true, true);
        accStatusCold.Status__c = Label.AccountStatusCold;
        
        Account accStatusHot = acc.clone(true, false, true, true);
        accStatusHot.Status__c = Label.AccountStatusHot;

        AccountDomain accDomain = AccountDomain.getInstance();

        Test.startTest();
        Boolean accWithoutStatusChange = accDomain.validateParentAccountCriation(acc, acc, true);
        Boolean accWitHotStatusChange = accDomain.validateParentAccountCriation(accStatusHot, acc, true);
        Boolean accWitColdStatusChange = accDomain.validateParentAccountCriation(accStatusCold, acc, true);
        Boolean accWithoutParentUpdatePermission = accDomain.validateParentAccountCriation(accStatusCold, acc, false);
        Test.stopTest();
        System.assert(!accWithoutStatusChange);
        System.assert(!accWitHotStatusChange);
        System.assert(accWitColdStatusChange);
        System.assert(!accWithoutParentUpdatePermission);
    }
    
    @isTest
    private static void createParenteAccountTest() {
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];

        AccountDomain accDomain = AccountDomain.getInstance();
        Test.startTest();
        Account createdAccount = accDomain.createParenteAccount(acc);
        Test.stopTest();
        System.assertEquals(acc.Id, createdAccount.ParentId);
        System.assertEquals(Label.AccountStatusCold, createdAccount.Status__c);
    }
}
