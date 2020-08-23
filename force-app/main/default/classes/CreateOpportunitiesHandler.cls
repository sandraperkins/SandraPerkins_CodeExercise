public with sharing class CreateOpportunitiesHandler {
    public static void createOpportunities(List<Account> accts, Boolean createResidential, Boolean createCommercial) {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account a : accts) {
            if(createResidential) {
                Opportunity residentialOpp = new Opportunity(
                    Name = 'Default Residential Opp',
                    StageName = 'Prospecting',
                    CloseDate = Date.today() + 30,
                    AccountId = a.Id
                );
                oppList.add(residentialOpp);
            }
            if(createCommercial) {
                Opportunity commercialOpp = new Opportunity(
                    Name = 'Default Commercial Opp',
                    StageName = 'Prospecting',
                    CloseDate = Date.today() + 30,
                    AccountId = a.Id
                );
                oppList.add(commercialOpp);
            }
            
        }
        insert oppList;
    }
    public static void checkOpportunities(List<Account> updatedAccts) {
        List<Opportunity> oppList = new List<Opportunity>();
        Boolean createResidential = false;
        Boolean createCommercial = false;
        
        List<Account> acctsWithOpps = 
            [SELECT Id, (SELECT Name FROM Opportunities WHERE Name LIKE 'Default%') FROM Account
            WHERE Id IN :updatedAccts AND Type = 'Prospect'];
        System.debug('acctsWithOpps: ' + acctsWithOpps);

        for(Account a : acctsWithOpps) {
            List<Opportunity> defaultOpps = a.Opportunities;
            System.debug('defaultOpps: ' + defaultOpps);
            List<String> oppNames = new List<String>();
            for(Opportunity opp : defaultOpps) {
                oppNames.add(opp.Name);
            }
            if(defaultOpps.size() < 2) {
                if(!oppNames.contains('Default Residential Opp')) {
                    createResidential = true;
                }
                if(!oppNames.contains('Default Commercial Opp')) {
                    createCommercial = true;
                }
                createOpportunities(updatedAccts, createResidential, createCommercial);
            }
        }
    }
}
