public interface ILookupSearchProvider {
    List<LookupSearchResult> search(String searchKey, List<String> selectedIds, String params);
    List<LookupSearchResult> getDefaultResults(String params);
    List<LookupNewRecordOption> getNewRecordOptions(String params);
}
