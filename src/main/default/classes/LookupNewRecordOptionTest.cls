@IsTest
private class LookupNewRecordOptionTest {
    @IsTest
    static void testConstructor() {
        Test.startTest();
        LookupNewRecordOption option = new LookupNewRecordOption(
            'Account',
            'New Account',
            'name=My Account Test,NumberOfEmployees=35000'
        );
        Test.stopTest();

        System.assertEquals('Account', option.getValue());
        System.assertEquals('New Account', option.getLabel());
        System.assertEquals('name=My Account Test,NumberOfEmployees=35000', option.getDefaults());
    }
}
