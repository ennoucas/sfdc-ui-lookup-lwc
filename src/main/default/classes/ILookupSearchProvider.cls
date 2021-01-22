public interface ILookupSearchProvider {
    List<LookupSearchResult> search(String searchKey, List<String> selectedIds, String filterParams);
    List<LookupSearchResult> getDefaultResults(String filterParams);
    List<LookupNewRecordOption> getNewRecordOptions();
}
