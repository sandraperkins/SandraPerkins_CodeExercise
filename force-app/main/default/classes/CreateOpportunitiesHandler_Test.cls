@isTest
public with sharing class CreateOpportunitiesHandler_Test {
    @isTest
    public static void testCreateOppSingle(){
        Account testAccount = new Account(Name = 'Test Account', Type = 'Customer - Direct');
        insert testAccount;
        List<Opportunity> defaultOpps = [SELECT Id FROM Opportunity WHERE Name LIKE 'Default%' AND AccountId = :testAccount.Id];
        System.assertEquals(2, defaultOpps.size(), 'Opportunity size was not 2');
    }
    @isTest
    public static void testCreateOppBatch() {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<5; i++) {
            accounts.add(new Account (
                Name = 'Account ' + i,
                Type = 'Customer - Direct'
            ));
        }
        insert accounts;
        List<Opportunity> defaultOpps = [SELECT Id FROM Opportunity WHERE (Name = 'Default Residential Opp' OR Name = 'Default Commercial Opp')
                                        AND AccountId IN :accounts];
        System.debug('defaultOpps: ' + defaultOpps);
        System.assertEquals(10, defaultOpps.size(), 'Opportunity size was not 10');
    }
    @isTest
    public static void testcheckOppSingle() {
        Account testAccount = new Account(Name = 'Test Account 2', Type = 'Customer - Direct');
        insert testAccount;
        Opportunity commercialOpp = [SELECT Id FROM Opportunity WHERE Name = 'Default Commercial Opp' AND AccountId = :testAccount.Id];
        delete commercialOpp;
        testAccount.Type = 'Prospect';
        update testAccount;
        List<Opportunity> defaultOpps = [SELECT Id FROM Opportunity WHERE Name LIKE 'Default%' AND AccountId = :testAccount.Id];
        System.assertEquals(2, defaultOpps.size(), 'Opportunity size was not 2');
    }
    @isTest
    public static void testcheckOppBatch() {
        List<Account> accounts = new List<Account>();
            for(Integer i=0; i<5; i++) {
                accounts.add(new Account (
                    Name = 'Check Account ' + i,
                    Type = 'Customer - Direct'
                ));
            }
            insert accounts;
        List<Account> updatedAccts = new List<Account>();
        List<Opportunity> defaultOpps = [SELECT Id FROM Opportunity WHERE Name LIKE 'Default%' AND AccountId IN :accounts];
        System.debug('defaultOpps: ' + defaultOpps.size());
        delete defaultOpps;
        for(Account a : accounts) {
            a.Type = 'Prospect';
            updatedAccts.add(a);
        }
        update updatedAccts;
        List<Opportunity> newDefaultOpps = [SELECT Id FROM Opportunity WHERE Name Like 'Default%' AND AccountId IN :updatedAccts];
        System.debug('newDefaultOpps: ' + newDefaultOpps.size());
        System.assertEquals(10, newDefaultOpps.size(), 'Opportunity size was not 10');
    }
}
