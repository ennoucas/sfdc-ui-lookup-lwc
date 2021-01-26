public with sharing class LookupSearchController {
    @TestVisible
    private class LookupSearchException extends Exception {
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(String providerClass, String params) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance()).search(params);
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> getDefaultResults(String providerClass, String params) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance()).getDefaultResults(params);
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupNewRecordOption> getNewRecordOptions(String providerClass, String params) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance()).getNewRecordOptions(params);
    }

    private static void checkProviderClass(String providerClass) {
        if (providerClass == null || Type.forName(providerClass) == null) {
            throw new LookupSearchException('The provider class was not found');
        } else if (!ILookupSearchProvider.class.isAssignableFrom(Type.forName(providerClass))) {
            throw new LookupSearchException('The provider class does not extends LookupSearchProvider');
        }
    }
}
