const { createLookupElement, inputSearchTerm, flushPromises, SAMPLE_SEARCH_ITEMS } = require('./lookupTest.utils');
import search from '@salesforce/apex/LookupSearchController.search';

const SAMPLE_SEARCH_KEY = 'sample';
const SAMPLE_PROVIDER_CLASS = 'providerClassName';
const SAMPLE_SEARCH_PARAMS = 'sampleSearchParams';

// Mocking imperative Apex method call
jest.mock(
    '@salesforce/apex/LookupSearchController.search',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-lookup calling apex methods with right params', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });
    it('can search', () => {
        jest.useFakeTimers();
        search.mockResolvedValue(SAMPLE_SEARCH_ITEMS);

        // Create lookup with search handler
        const lookupEl = createLookupElement({
            providerClass: SAMPLE_PROVIDER_CLASS,
            searchParams: SAMPLE_SEARCH_PARAMS
        });

        // Simulate search term input
        inputSearchTerm(lookupEl, SAMPLE_SEARCH_KEY);

        return flushPromises().then(() => {
            expect(search).toHaveBeenCalledWith({
                providerClass: SAMPLE_PROVIDER_CLASS,
                searchKey: SAMPLE_SEARCH_KEY,
                selectedIds: [],
                params: SAMPLE_SEARCH_PARAMS
            });
        });
    });
});
