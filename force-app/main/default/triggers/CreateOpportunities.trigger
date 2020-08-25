trigger CreateOpportunities on Account (after insert, after update) {
 if(Trigger.isInsert && Trigger.isAfter) {
     CreateOpportunitiesHandler.createOpportunities(Trigger.new);

 } else if(Trigger.isUpdate && Trigger.isAfter) {
     CreateOpportunitiesHandler.checkOpportunities(Trigger.new);
 }

}