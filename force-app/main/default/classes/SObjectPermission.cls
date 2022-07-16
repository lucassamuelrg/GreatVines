public with sharing class SObjectPermission {
    private final Schema.DescribeSObjectResult sObjectDescribe;
    public final Boolean read;
    public final Boolean create;
    public final Boolean edit;

    public SObjectPermission(String sObjectApiName) {
        this.sObjectDescribe = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
        this.read = sObjectDescribe.isAccessible();
        this.create = sObjectDescribe.isCreateable();
        this.edit = sObjectDescribe.isUpdateable();
    }

    public Boolean validateEditFieldPermission(String fieldApiName) {
        return sObjectDescribe.fields.getMap().get(fieldApiName).getDescribe().isUpdateable();
    }
}