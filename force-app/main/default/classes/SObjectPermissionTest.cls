@isTest
public with sharing class SObjectPermissionTest {
    @IsTest
    static void contrutorTest(){
        Test.startTest();
        SObjectPermission accountPermission = new SObjectPermission('Account');
        Test.stopTest();
        System.assert(accountPermission.read);
        System.assert(accountPermission.create);
        System.assert(accountPermission.edit);
    }
    
    @IsTest
    static void validateEditFieldPermissionTest(){
        SObjectPermission accountPermission = new SObjectPermission('Account');
        Test.startTest();
        Boolean editAccountName = accountPermission.validateEditFieldPermission('Name');
        Boolean editAccountCreatedDate = accountPermission.validateEditFieldPermission('CreatedDate');
        Test.stopTest();
        System.assert(editAccountName);
        System.assert(!editAccountCreatedDate);
    }

}