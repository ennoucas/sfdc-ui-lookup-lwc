public with sharing class LookupSearchController {
    @TestVisible
    private class LookupSearchException extends Exception {
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> search(
        String providerClass,
        String searchKey,
        List<String> selectedIds,
        String searchParams
    ) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance())
            .search(searchKey, selectedIds, searchParams);
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> getDefaultResults(String providerClass, String searchParams) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance()).getDefaultResults(searchParams);
    }

    @AuraEnabled(cacheable=true)
    public static List<LookupNewRecordOption> getNewRecordOptions(String providerClass) {
        checkProviderClass(providerClass);
        return ((ILookupSearchProvider) Type.forName(providerClass).newInstance()).getNewRecordOptions();
    }

    private static void checkProviderClass(String providerClass) {
        if (providerClass == null || Type.forName(providerClass) == null) {
            throw new LookupSearchException('The provider class was not found');
        } else if (!ILookupSearchProvider.class.isAssignableFrom(Type.forName(providerClass))) {
            throw new LookupSearchException('The provider class does not extends LookupSearchProvider');
        }
    }
}
