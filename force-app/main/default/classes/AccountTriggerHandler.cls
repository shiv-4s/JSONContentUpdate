public class AccountTriggerHandler {
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
      public static void updateDescription(List<Account> acctList){
        Map<String, Account> sObjectMap = new Map<String, Account>(acctList);
		System.debug('StartingString================= ' + sObjectMap);
        Map<String, Object> acctMapValue;
        Map<String, Object> descMapValue;
        Map<String, Object> detailsMap;
        Map<String, Object> attrsMap;
        Map<String, Object> valueMap;
        Map<String, Object> moreDetailsMap;
        Map<String, Object> priceMap;
        List<Object> mtdList;
         String finalString;

        // iterating the map values for checking the description field.
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
                    System.debug('priceMap==========================94=========== ' + detailsMap);

                }
                if(detailsMap.containskey('price') && (detailsMap.get('price') != null ) ){
                    Integer totalPrice = Integer.valueOf((String)acctList[0].product_count__c)*Integer.valueOf(detailsMap.get('unitprice'));
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
                        System.debug('priceMap==========================116=========== ' + priceMap);
                    }
                    if(priceMap.containskey('price') && (priceMap.get('price') != null ) ){
                        Integer totalPrice = Integer.valueOf((String)acctList[0].product_count__c)*Integer.valueOf(priceMap.get('unitprice'));
                        priceMap.put('price', totalPrice);
                    }
                }
            }
        }
        
        finalString = JSON.serialize(acctMapValue);
        System.debug('finalString============' + acctMapValue);
        List<Account> updatedlist = new List<Account>();
        for(Account acct : acctList){
            acct.Description = finalString;
            updatedlist.add(acct);
        }
    }
}