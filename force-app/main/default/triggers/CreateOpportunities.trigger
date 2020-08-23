trigger CreateOpportunities on Account (after insert, after update) {
 if(Trigger.isInsert && Trigger.isAfter) {
     CreateOpportunitiesHandler.createOpportunities(Trigger.new, true, true);

 } else if(Trigger.isUpdate && Trigger.isAfter) {
     System.debug('inside Trigger.isUpdate');
     CreateOpportunitiesHandler.checkOpportunities(Trigger.new);
 }

}