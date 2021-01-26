public abstract with sharing class LookupSearchProvider implements ILookupSearchProvider {
    public abstract List<LookupSearchResult> search(String params);
    public abstract List<LookupSearchResult> getDefaultResults(String params);

    public virtual List<LookupNewRecordOption> getNewRecordOptions(String params) {
        return new List<LookupNewRecordOption>();
    }
}
