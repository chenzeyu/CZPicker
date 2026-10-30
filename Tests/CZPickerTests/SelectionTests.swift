import XCTest
@testable import CZPickerUI

final class SelectionTests: XCTestCase {
    func testFilteringDoesNotChangeStableSelections() {
        var draft = SelectionDraft(selection: Set(["a"]), orderedIDs: ["a", "b", "c"], mode: .multiple())
        draft.toggle("c", enabled: true)
        XCTAssertEqual(draft.ids, ["a", "c"])
        draft.reconcile(draft.ids, orderedIDs: ["c", "a", "b"])
        XCTAssertEqual(draft.ids, ["a", "c"])
    }
    func testLimitStillPermitsDeselectionAndDisabledItemsCannotChange() {
        var draft = SelectionDraft(selection: Set([1]), orderedIDs: [1, 2, 3], mode: .multiple(maximum: 1))
        draft.toggle(2, enabled: true)
        XCTAssertEqual(draft.ids, [1])
        draft.toggle(1, enabled: false)
        XCTAssertEqual(draft.ids, [1])
        draft.toggle(1, enabled: true)
        draft.toggle(2, enabled: true)
        XCTAssertEqual(draft.ids, [2])
    }
    func testSingleSelectionReplacesAndCanClear() {
        var draft = SelectionDraft(selection: Set([1]), orderedIDs: [1, 2], mode: .single)
        draft.toggle(2, enabled: true)
        XCTAssertEqual(draft.ids, [2])
        draft.toggle(2, enabled: true)
        XCTAssertTrue(draft.ids.isEmpty)
    }
    func testDraftDoesNotMutateCommittedSelection() {
        let committed: Set<Int> = [1]
        var draft = SelectionDraft(selection: committed, orderedIDs: [1, 2], mode: .multiple())
        draft.toggle(2, enabled: true)
        XCTAssertEqual(committed, [1])
        XCTAssertEqual(draft.ids, [1, 2])
    }
    func testReloadPrunesRemovedIDsAndInitialSelectionIsDeterministic() {
        var draft = SelectionDraft(selection: Set([1, 2, 3, 99]), orderedIDs: [3, 3, 2, 1], mode: .multiple(maximum: 2))
        XCTAssertEqual(draft.ids, [3, 2])
        draft.reconcile(draft.ids, orderedIDs: [1, 2])
        XCTAssertEqual(draft.ids, [2])
    }
    func testZeroAndNegativeLimits() {
        for maximum in [0, -1] {
            var draft = SelectionDraft(selection: Set([1]), orderedIDs: [1, 2], mode: .multiple(maximum: maximum))
            draft.toggle(2, enabled: true)
            XCTAssertTrue(draft.ids.isEmpty)
        }
    }
}
