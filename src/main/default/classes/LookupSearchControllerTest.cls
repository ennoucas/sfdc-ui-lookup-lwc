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
        System.assertEquals('User Test 1', results[0].getTitle());
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
        System.assertEquals('User Test 2', results[0].getTitle());
    }

    private class BadProviderExample {
    }

    public class ProviderExample implements LookupSearchProvider {
        private Integer fakeIdCount = 0;
        private final String ID_PATTERN = '000000000000';

        public List<LookupSearchResult> search(String searchKey, List<String> selectedIds, String searchParams) {
            return new List<LookupSearchResult>{
                new LookupSearchResult(
                    generateId(Account.SObjectType),
                    'User',
                    'standard:user',
                    'User Test 1',
                    'System Administrator'
                )
            };
        }
        public List<LookupSearchResult> getDefaultResults(String searchParams) {
            return new List<LookupSearchResult>{
                new LookupSearchResult(
                    generateId(Account.SObjectType),
                    'User',
                    'standard:user',
                    'User Test 2',
                    'System Administrator'
                )
            };
        }

        private Id generateId(Schema.SObjectType sobjectType) {
            String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
            fakeIdCount++;

            String fakeIdPrefix = ID_PATTERN.substring(0, 12 - fakeIdCount.format().length());

            return Id.valueOf(keyPrefix + fakeIdPrefix + fakeIdCount);
        }
    }
}
