public with sharing class SampleLookupProvider extends LookupSearchProvider {
    class SearchParams {
        String searchKey;
    }

    override public List<LookupSearchResult> search(String params) {
        SearchParams searchParam = (SearchParams) JSON.deserialize(params, SearchParams.class);
        List<Account> accounts = [SELECT ID, Name, BillingCountry FROM Account WHERE Name LIKE :searchParam.searchKey];
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Account acc : accounts) {
            results.add(new LookupSearchResult(acc.Id, 'Account', 'standard:account', acc.Name, acc.BillingCountry));
        }
        return results;
    }

    override public List<LookupSearchResult> getDefaultResults(String params) {
        List<Account> accounts = [SELECT ID, Name, BillingCountry FROM Account ORDER BY LastViewedDate LIMIT 1];
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Account acc : accounts) {
            results.add(new LookupSearchResult(acc.Id, 'Account', 'standard:account', acc.Name, acc.BillingCountry));
        }
        return results;
    }

    override public List<LookupNewRecordOption> getNewRecordOptions(String params) {
        return new List<LookupNewRecordOption>{ new LookupNewRecordOption('Account', 'New Account', '') };
    }
}
