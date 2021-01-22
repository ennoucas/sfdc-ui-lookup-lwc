public virtual class LookupNewRecordOption {
    protected String value;
    protected String label;
    protected String defaults;

    public LookupNewRecordOption(String value, String label, String defaults) {
        this.value = value;
        this.label = label;
        this.defaults = defaults;
    }

    @AuraEnabled
    public string getValue() {
        return value;
    }

    @AuraEnabled
    public String getLabel() {
        return label;
    }

    @AuraEnabled
    public String getDefaults() {
        return defaults;
    }
}
