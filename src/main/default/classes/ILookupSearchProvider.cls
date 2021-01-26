public interface ILookupSearchProvider {
    List<LookupSearchResult> search(String params);
    List<LookupSearchResult> getDefaultResults(String params);
    List<LookupNewRecordOption> getNewRecordOptions(String params);
}
