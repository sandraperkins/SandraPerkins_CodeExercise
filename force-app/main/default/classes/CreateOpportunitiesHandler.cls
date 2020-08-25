public with sharing class CreateOpportunitiesHandler {
    // takes in inserted accounts and create two default opportunities
    public static void createOpportunities(List<Account> accts) {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account a: accts) {
            Opportunity residentialOpp = new Opportunity(
                Name = 'Default Residential Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today() + 30,
                AccountId = a.Id
            );
            oppList.add(residentialOpp);
            Opportunity commercialOpp = new Opportunity(
                Name = 'Default Commercial Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today() + 30,
                AccountId = a.Id
            );
            oppList.add(commercialOpp);
        }
        insert oppList;
    }
    /* checks updated accounts for a type change to 'Prospect'
       checks if the default opportunities still exist
       if they do not, then recreate them and send an email
    */
    public static void checkOpportunities(List<Account> updatedAccts) {
        List<Opportunity> oppList = new List<Opportunity>();
            List<String> addresses = new List<String>();
            List<Account> acctsWithOpps = 
                    [SELECT Id, Owner.Email, (SELECT Name FROM Opportunities WHERE Name LIKE 'Default%') FROM Account
                    WHERE Id IN :updatedAccts AND Type = 'Prospect'];
                System.debug('acctsWithOpps: ' + acctsWithOpps);
                List<Opportunity> oppsToCreate = new List<Opportunity>();
                for(Account a : acctsWithOpps) {
                    Boolean createResidential = false;
                    Boolean createCommercial = false;
                    List<Opportunity> defaultOpps = a.Opportunities;
                    System.debug('defaultOpps: ' + defaultOpps.size());
                    List<String> oppNames = new List<String>();
                    for(Opportunity opp : defaultOpps) {
                        oppNames.add(opp.Name);
                    }
                    if(defaultOpps.size() < 2) {
                        if(!oppNames.contains('Default Residential Opp')) {
                            createResidential = true;
                            Opportunity residentialOpp = new Opportunity(
                                Name = 'Default Residential Opp',
                                StageName = 'Prospecting',
                                CloseDate = Date.today() + 30,
                                AccountId = a.Id
                            );
                            oppsToCreate.add(residentialOpp);
                        }
                        if(!oppNames.contains('Default Commercial Opp')) {
                            createCommercial = true;
                            Opportunity commercialOpp = new Opportunity(
                                Name = 'Default Commercial Opp',
                                StageName = 'Prospecting',
                                CloseDate = Date.today() + 30,
                                AccountId = a.Id
                            );
                            oppsToCreate.add(commercialOpp);
                        }
                    }
                    if(createResidential || createCommercial) {
                        addresses.add(a.Owner.Email);
                    }
                }
                insert oppsToCreate;
                System.debug('email addresses: ' + addresses);
                String subject = 'Account Opportunities Changed';
                String body = 'This email is to inform you that the default opportunities on an account you own were altered or deleted. They have since been restored.';
                EmailManager.sendMail(addresses, subject, body);
    }
}
