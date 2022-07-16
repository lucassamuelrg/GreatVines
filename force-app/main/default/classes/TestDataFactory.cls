@isTest
public with sharing class TestDataFactory {
    public static Account createAccount(String name, String status) {
        return new Account(Name = name, Status__c = status);
    }
}
