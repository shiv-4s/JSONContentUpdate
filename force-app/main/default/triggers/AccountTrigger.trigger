trigger AccountTrigger on Account (After update) {
    
     Map<Id, Account> oldAccountMap = Trigger.oldMap;
     Map<Id, Account> newAccountMap = Trigger.newMap;
    
    for (Id accountId : newAccountMap.keySet()) {
        Account oldAccount = oldAccountMap.get(accountId);
        Account newAccount = newAccountMap.get(accountId);
        
        if (oldAccount.product_count__c != newAccount.product_count__c) {
                if(!AccountTriggerHandler.isdisabletrigger){
                    AccountTriggerHandler.updateDescription(Trigger.Old, oldAccountMap);
         }
    
        }
    } 
    
}