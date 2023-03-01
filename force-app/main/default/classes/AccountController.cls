public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name FROM Account WITH SECURITY_ENFORCED LIMIT 10];
    }
    
    @AuraEnabled(cacheable=true)
    public static Account getSingleAccount() {
        return [
            SELECT Id, Name, Phone, Type
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
    
    public static String mapObjectData(Account acc){
        AccountProductHandler.ATTRMDT attrValue = new AccountProductHandler.ATTRMDT();
        AccountProductHandler.Details detailValue = new AccountProductHandler.Details();
        return JSON.serialize(detailValue);
    }
    
    public static void updateDescription(List<Account> acctList){
        
        
        Map<String, Account> sObjectMap = new Map<String, Account>(acctList);
        Map<String, Object> acctMapValue;
        Map<String, Object> descMapValue;
        Map<String, Object> detailsMap;
        Map<String, Object> attrsMap;
        Map<String, Object> valueMap;
        Map<String, Object> moreDetailsMap;
        Map<String, Object> priceMap;
        List<Object> mtdList;
        
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
                    String productCount = (String)acctList[0].product_count__c;
                    Integer priceValue = Integer.valueOf(detailsMap.get('price'));
                    Integer intValue = Integer.valueOf(productCount)*priceValue;
                    detailsMap.put('price',intValue );
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
                        String productCount = (String)acctList[0].product_count__c;
                        Integer priceValue = Integer.valueOf(priceMap.get('price'));
                        Integer intValue = Integer.valueOf(productCount)*priceValue;
                        priceMap.put('price',intValue );
                    }
                }
            }
        }
        
        
        String finalString = JSON.serialize(acctMapValue);
        //here updating the description value and updating the value.
        acctList[0].Description =  finalString;
		UPDATE	acctList[0];
        
        System.debug('finalString=================='  + finalString);
        
    }
}