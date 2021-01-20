public with sharing class SampleLookupProvider {
    public List<LookupSearchResult> search(String searchKey, List<String> selectedIds, String searchParams) {
        String key = String.escapeSingleQuotes(searchKey);
        List<Account> accounts = [SELECT ID, Name, BillingCountry FROM Account WHERE Name LIKE :key];
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Account acc : accounts) {
            results.add(new LookupSearchResult(acc.Id, 'Account', 'standard:account', acc.Name, acc.BillingCountry));
        }
        return results;
    }

    public List<LookupSearchResult> getDefaultResults(String searchParams) {
        List<Account> accounts = [SELECT ID, Name, BillingCountry FROM Account ORDER BY LastViewedDate LIMIT 1];
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        for (Account acc : accounts) {
            results.add(new LookupSearchResult(acc.Id, 'Account', 'standard:account', acc.Name, acc.BillingCountry));
        }
        return results;
    }
}
