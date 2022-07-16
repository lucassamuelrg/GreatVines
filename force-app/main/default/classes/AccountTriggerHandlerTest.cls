@isTest
public with sharing class AccountTriggerHandlerTest {
    @TestSetup
    static void setup(){
        Account acc = TestDataFactory.createAccount('Account Test', null);
        insert acc;
    }

    @isTest
    private static void parentAccountCriationInsertTest() {
        Account acc = TestDataFactory.createAccount('Account Test', Label.AccountStatusCold);
        Test.startTest();
        insert acc;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Account WHERE ParentId = :acc.Id].size());
    }

    @isTest
    private static void parentAccountCriationUpdateTest() {
        Account acc = [SELECT Id, Name, Status__c FROM Account LIMIT 1];
        acc.Status__c = Label.AccountStatusCold;

        Test.startTest();
        update acc;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM Account WHERE ParentId = :acc.Id].size());
    }
}
