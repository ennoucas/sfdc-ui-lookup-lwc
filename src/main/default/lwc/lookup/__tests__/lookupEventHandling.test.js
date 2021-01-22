const {
    createLookupElement,
    inputSearchTerm,
    flushPromises,
    SAMPLE_SEARCH_ITEMS,
    SAMPLE_NEW_RECORD_OPTION
} = require('./lookupTest.utils');
import { getNavigateCalledWith } from 'lightning/navigation';

import search from '@salesforce/apex/LookupSearchController.search';

import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import getNewRecordOptions from '@salesforce/apex/LookupSearchController.getNewRecordOptions';

const getNewRecordOptionsAdapter = registerApexTestWireAdapter(getNewRecordOptions);

const SAMPLE_SEARCH = 'sample';

const ARROW_DOWN = 40;
const ENTER = 13;

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

describe('c-lookup event handling', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('can clear selection when single entry', () => {
        // Create lookup
        const lookupEl = createLookupElement({
            isMultiEntry: false,
            selection: SAMPLE_SEARCH_ITEMS[0]
        });

        // Clear selection
        const clearSelButton = lookupEl.shadowRoot.querySelector('button');
        clearSelButton.click();
        // Check selection
        expect(lookupEl.selection.length).toBe(0);
    });

    it('can clear selection when multi entry', () => {
        // Create lookup
        const lookupEl = createLookupElement({
            isMultiEntry: true,
            selection: SAMPLE_SEARCH_ITEMS
        });

        // Remove a selected item
        const selPills = lookupEl.shadowRoot.querySelectorAll('lightning-pill');
        selPills[0].dispatchEvent(new CustomEvent('remove'));
        // Check selection
        expect(lookupEl.selection.length).toBe(SAMPLE_SEARCH_ITEMS.length - 1);
    });

    it("doesn't remove pill when multi entry and disabled", () => {
        // Create lookup
        const lookupEl = createLookupElement({
            isMultiEntry: true,
            disabled: true,
            selection: SAMPLE_SEARCH_ITEMS
        });

        // Remove a selected item
        const selPills = lookupEl.shadowRoot.querySelectorAll('lightning-pill');
        selPills[0].dispatchEvent(new CustomEvent('remove'));
        // Check selection
        expect(lookupEl.selection.length).toBe(SAMPLE_SEARCH_ITEMS.length);
    });

    it('can select item with mouse', () => {
        jest.useFakeTimers();
        search.mockResolvedValue(SAMPLE_SEARCH_ITEMS);

        // Create lookup with search handler
        const lookupEl = createLookupElement();

        // Simulate search term input
        inputSearchTerm(lookupEl, SAMPLE_SEARCH);

        return flushPromises().then(() => {
            // Simulate mouse selection
            const searchResultItem = lookupEl.shadowRoot.querySelector('span[data-recordid]');
            searchResultItem.click();

            // Check selection
            expect(lookupEl.selection.length).toBe(1);
            expect(lookupEl.selection[0].id).toBe(SAMPLE_SEARCH_ITEMS[0].id);
        });
    });

    it('can select item with keyboard', () => {
        jest.useFakeTimers();
        search.mockResolvedValue(SAMPLE_SEARCH_ITEMS);

        // Create lookup with search handler
        const lookupEl = createLookupElement();

        // Set search term and force input change
        const searchInput = lookupEl.shadowRoot.querySelector('input');
        searchInput.focus();
        searchInput.value = SAMPLE_SEARCH;
        searchInput.dispatchEvent(new CustomEvent('input'));

        // Disable search throttling
        jest.runAllTimers();

        return flushPromises().then(() => {
            // Simulate keyboard navigation
            searchInput.dispatchEvent(new KeyboardEvent('keydown', { keyCode: ARROW_DOWN }));
            searchInput.dispatchEvent(new KeyboardEvent('keydown', { keyCode: ENTER }));

            // Check selection
            expect(lookupEl.selection.length).toBe(1);
            expect(lookupEl.selection[0].id).toBe(SAMPLE_SEARCH_ITEMS[0].id);
        });
    });

    it('can create new record', () => {
        jest.useFakeTimers();
        search.mockResolvedValue(SAMPLE_SEARCH_ITEMS);

        // Create lookup with search handler
        const lookupEl = createLookupElement();

        // Simulate search term input
        inputSearchTerm(lookupEl, SAMPLE_SEARCH);
        getNewRecordOptionsAdapter.emit(SAMPLE_NEW_RECORD_OPTION);

        return flushPromises().then(() => {
            // Simulate mouse selection
            const newRecordEl = lookupEl.shadowRoot.querySelector('div[data-sobject]');
            expect(newRecordEl).not.toBeNull();
            const labelEl = newRecordEl.querySelector('.slds-listbox__option-text');
            expect(labelEl.textContent).toBe(SAMPLE_NEW_RECORD_OPTION[0].label);
            newRecordEl.click();

            // Verify that we navigate to the right page
            const { pageReference } = getNavigateCalledWith();
            expect(pageReference.type).toBe('standard__objectPage');
            expect(pageReference.attributes.objectApiName).toBe(SAMPLE_NEW_RECORD_OPTION[0].value);
            expect(pageReference.attributes.actionName).toBe('new');
            expect(pageReference.state.defaultFieldValues).toBe(SAMPLE_NEW_RECORD_OPTION[0].defaults);
        });
    });
});
