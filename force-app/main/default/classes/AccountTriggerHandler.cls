public class AccountTriggerHandler {
    public static Boolean isdisabletrigger = false;
    public static void updateRating(List<Account> accList){
        for(Account acc : accList){
            if(acc.Industry <> null && acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
        }
    }
    
    public static void updateAddress(List<Account> accList){
        for(Account acc : accList){
            if(acc.CopyBillingToShipping__c && acc.BillingCity <> null && acc.BillingCountry <> null && acc.BillingPostalCode <> null &&
               acc.BillingState <> null && acc.BillingStreet <> null){
                   acc.ShippingCity = acc.BillingCity;
                   acc.ShippingCountry = acc.BillingCountry;
                   acc.ShippingState = acc.BillingState;
                   acc.ShippingStreet = acc.BillingStreet;
                   acc.ShippingPostalCode = acc.BillingPostalCode;
               }
        }
    }
    
    public static void updateDescription(List<Account> accts){
        // map acc Id to price for old valuces
        // 
        Integer quantity;
		Set<Id> accIds = new Set<Id>();
        for(Account a : accts){
            accIds.add(a.Id);
        }
        List<Account> acctList = [SELECT Id, Description,Name,product_count__c FROM Account WHERE Id =: accIds];
        Map<String, Account> sObjectMap = new Map<String, Account>(acctList);
        Map<String, Object> acctMapValue;
        Map<String, Object> descMapValue;
        Map<String, Object> detailsMap;
        Map<String, Object> attrsMap;
        Map<String, Object> valueMap;
        Map<String, Object> moreDetailsMap;
        Map<String, Object> priceMap;
        List<Object> mtdList;
        String finalString;
        
        for(Account acct : sObjectMap.values()){
            acctMapValue = (Map<String, Object>)JSOn.deserializeUntyped((String)(acct.get('Description')));
            if(acctMapValue.containsKey('ATTR_VALUE') && acctMapValue.containsKey('ATTRMDT')){
                mtdList = (List<Object>)acctMapValue.get('ATTRMDT');
                attrsMap = (Map<String, Object>)acctMapValue.get('ATTR_VALUE');
            }
            
        }
        
        for(Object obj : mtdList){
            descMapValue = (Map<String, Object>)obj;
            if(descMapValue.containsKey('details') && descMapValue.get('brand') == 'iphone'){
                detailsMap = (Map<String, Object>)descMapValue.get('details');
                
                if(detailsMap.containskey('count')){
                    detailsMap.put('count',acctList[0].product_count__c );
                    
                }
                if(detailsMap.containskey('price') && (detailsMap.get('price') != null)){
                    Integer priceValue = Integer.valueOf(detailsMap.get('price'));
                    Integer totalPrice = priceValue*Integer.valueOf(detailsMap.get('count'));
                    detailsMap.put('price',totalPrice);
                }
                
            }
        }
        
        if(attrsMap.containsKey('value')){
            valueMap = (Map<String, Object>)attrsMap.get('value');
            if(valueMap.containsKey('moredetails')){
                moreDetailsMap = (Map<String, Object>)valueMap.get('moredetails');
                if(moreDetailsMap.containsKey('price') && moreDetailsMap.get('brand') == 'samsung'){
                    priceMap = (Map<String, Object>)moreDetailsMap.get('price');
                    if(priceMap.containskey('count')){
                        priceMap.put('count',acctList[0].product_count__c );
                    }
                    if(priceMap.containskey('price') && (priceMap.get('price') != null ) ){
                        Integer priceValue = Integer.valueOf(priceMap.get('price'));
                        // old map accId= price / Acc.product count = unit price
                        // unit price *new count
                        Integer totalPrice = priceValue*Integer.valueOf(priceMap.get('count'));
                        priceMap.put('price',totalPrice );
                        
                    }
                }
            }
        }
        
        finalString = JSON.serialize(acctMapValue);
        List<Account> updatedlist = new List<Account>();
        for(Account acct : acctList){
            acct.Description = finalString;
            updatedlist.add(acct);
        }
        isdisabletrigger = true;
        UPDATE updatedlist;        
    }
}