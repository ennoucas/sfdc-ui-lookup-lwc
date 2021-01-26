@IsTest
private class LookupSearchControllerTest {
    @IsTest
    static void testSearchWithNoProvider() {
        Test.startTest();
        try {
            LookupSearchController.search('', 'test', null, null);
            System.assert(false);
        } catch (LookupSearchController.LookupSearchException e) {
            System.assert(true, 'A LookupSearchController.LookupSearchException should have been raised');
        }
        Test.stopTest();
    }

    @IsTest
    static void testSearchWithBadProvider() {
        Test.startTest();
        try {
            LookupSearchController.search('LookupSearchControllerTest.BadProviderExample', 'test', null, null);
            System.assert(false);
        } catch (LookupSearchController.LookupSearchException e) {
            System.assert(true, 'A LookupSearchController.LookupSearchException should have been raised');
        }
        Test.stopTest();
    }

    @IsTest
    static void testSearch() {
        Test.startTest();
        List<LookupSearchResult> results = LookupSearchController.search(
            'LookupSearchControllerTest.ProviderExample',
            'test',
            null,
            null
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('Company 1', results[0].getTitle());
    }

    @IsTest
    static void testGetDefaultResults() {
        Test.startTest();
        List<LookupSearchResult> results = LookupSearchController.getDefaultResults(
            'LookupSearchControllerTest.ProviderExample',
            null
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('Company 2', results[0].getTitle());
    }

    @IsTest
    static void testGetNewRecordOptions() {
        Test.startTest();
        List<LookupNewRecordOption> results = LookupSearchController.getNewRecordOptions(
            'LookupSearchControllerTest.ProviderExample',
            null
        );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('Account', results[0].getValue());
    }

    private class BadProviderExample {
    }

    public class ProviderExample extends LookupSearchProvider {
        override public List<LookupSearchResult> search(String searchKey, List<String> selectedIds, String params) {
            return new List<LookupSearchResult>{
                new LookupSearchResult(
                    '0010R00000yvEyRQAU',
                    'Account',
                    'standard:account',
                    'Company 1',
                    'San Francisco'
                )
            };
        }
        override public List<LookupSearchResult> getDefaultResults(String params) {
            return new List<LookupSearchResult>{
                new LookupSearchResult('0010R00000yvEyRQAV', 'Account', 'standard:account', 'Company 2', 'Texas')
            };
        }
        override public List<LookupNewRecordOption> getNewRecordOptions(String params) {
            return new List<LookupNewRecordOption>{
                new LookupNewRecordOption('Account', 'New Account', 'name=My Account Test,NumberOfEmployees=35000')
            };
        }
    }
}
