import XCTest
import UIKit
import CZPicker

/// These tests describe the 0.4.3 API, not the modern sheet's selection rules.
@MainActor
final class LegacyTests: XCTestCase {
    private func picker(_ adapter: LegacyAdapter) -> CZPickerView {
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        picker.delegate = adapter
        picker.dataSource = adapter
        picker.animationDuration = 0
        return picker
    }

    func testOriginalDefaultsAndCustomization() {
        let picker = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        XCTAssertFalse(picker.needFooterView)
        XCTAssertFalse(picker.allowMultipleSelection)
        XCTAssertTrue(picker.tapBackgroundToDismiss)
        XCTAssertEqual(picker.animationDuration, 0.5)
        XCTAssertNil(picker.headerTitleFont)
        XCTAssertEqual(picker.headerTitleColor, .white)
        picker.pickerWidth = 250
        picker.headerBackgroundColor = .purple
        XCTAssertEqual(picker.pickerWidth, 250)
        XCTAssertEqual(picker.headerBackgroundColor, .purple)
    }

    func testPreselectionOrderingAndReloadSemanticsAreUnchanged() {
        let adapter = LegacyAdapter()
        let picker = picker(adapter)
        picker.allowMultipleSelection = true
        picker.setSelectedRows([2, 0, 2])
        XCTAssertEqual(picker.selectedRows() as? [Int], [2, 0, 2])
        adapter.count = 1
        picker.reloadData()
        // Legacy reload only reloads the table; it does not rewrite caller state.
        XCTAssertEqual(picker.selectedRows() as? [Int], [2, 0, 2])
        picker.unselectAll()
        XCTAssertEqual(picker.selectedRows() as? [Int], [])
    }

    func testExistingDelegateAndDataSourceOwnershipIsPreserved() {
        let picker = CZPickerView(headerTitle: "Test", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")!
        weak var adapterReference: LegacyAdapter?
        autoreleasepool {
            let adapter = LegacyAdapter()
            adapterReference = adapter
            picker.delegate = adapter
            picker.dataSource = adapter
        }
        XCTAssertNotNil(adapterReference)
        XCTAssertTrue(picker.delegate === adapterReference)
        picker.delegate = nil
        picker.dataSource = nil
        XCTAssertNil(adapterReference)
    }

    func testSingleSelectionStillConfirmsImmediatelyWithoutFooter() async {
        let adapter = LegacyAdapter()
        let confirmed = expectation(description: "Original single-selection callback")
        adapter.didConfirm = { confirmed.fulfill() }
        let picker = picker(adapter)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        let displayed = expectation(description: "Presentation completed")
        adapter.didDisplay = { displayed.fulfill() }
        picker.show(inContainer: window.rootViewController!.view)
        await fulfillment(of: [displayed], timeout: 3)
        await Task.yield()
        let table = descendants(picker).compactMap { $0 as? UITableView }.first!
        picker.tableView(table, didSelectRowAt: IndexPath(row: 1, section: 0))
        await fulfillment(of: [confirmed], timeout: 3)
        XCTAssertEqual(adapter.singleRow, 1)
        XCTAssertNil(picker.superview)
        XCTAssertEqual(Array(adapter.events.suffix(3)), ["willDismiss", "didDismiss", "single"])
    }

    func testMultipleSelectionConfirmationAndLifecycleOrder() async {
        let adapter = LegacyAdapter()
        let confirmed = expectation(description: "Original multiple-selection callback")
        adapter.didConfirm = { confirmed.fulfill() }
        let picker = picker(adapter)
        picker.allowMultipleSelection = true
        picker.setSelectedRows([2, 0])
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        let displayed = expectation(description: "Presentation completed")
        adapter.didDisplay = { displayed.fulfill() }
        picker.show(inContainer: window.rootViewController!.view)
        await fulfillment(of: [displayed], timeout: 3)
        await Task.yield()
        XCTAssertTrue(picker.needFooterView)
        let button = descendants(picker).compactMap { $0 as? UIButton }.first { $0.title(for: .normal) == "Confirm" }!
        let actions = button.actions(forTarget: picker, forControlEvent: .touchUpInside)!
        XCTAssertEqual(actions.count, 1)
        // Invoke the actual wired action; package tests do not run an application event loop.
        picker.perform(NSSelectorFromString(actions[0]), with: button)
        await fulfillment(of: [confirmed], timeout: 3)
        XCTAssertEqual(adapter.multipleRows, [2, 0])
        XCTAssertEqual(Array(adapter.events.suffix(3)), ["willDismiss", "didDismiss", "multiple"])
    }

    func testCancelPreservesSelectionsAndCallsOriginalCallback() async {
        let adapter = LegacyAdapter()
        let cancelled = expectation(description: "Original cancellation callback")
        adapter.didCancel = { cancelled.fulfill() }
        let picker = picker(adapter)
        picker.needFooterView = true
        picker.setSelectedRows([1])
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        let displayed = expectation(description: "Presentation completed")
        adapter.didDisplay = { displayed.fulfill() }
        picker.show(inContainer: window.rootViewController!.view)
        await fulfillment(of: [displayed], timeout: 3)
        await Task.yield()
        let button = descendants(picker).compactMap { $0 as? UIButton }.first { $0.title(for: .normal) == "Cancel" }!
        let actions = button.actions(forTarget: picker, forControlEvent: .touchUpInside)!
        XCTAssertEqual(actions.count, 1)
        // Invoke the actual wired action; package tests do not run an application event loop.
        picker.perform(NSSelectorFromString(actions[0]), with: button)
        await fulfillment(of: [cancelled], timeout: 3)
        XCTAssertEqual(picker.selectedRows() as? [Int], [1])
        XCTAssertNil(adapter.singleRow)
        XCTAssertEqual(Array(adapter.events.suffix(3)), ["willDismiss", "didDismiss", "cancel"])
    }

    private func descendants(_ view: UIView) -> [UIView] {
        view.subviews.flatMap { [$0] + descendants($0) }
    }
}

private final class LegacyAdapter: NSObject, CZPickerViewDataSource, CZPickerViewDelegate {
    var count = 3
    var events: [String] = []
    var singleRow: Int?
    var multipleRows: [Int]?
    var didConfirm: (() -> Void)?
    var didCancel: (() -> Void)?
    var didDisplay: (() -> Void)?
    func numberOfRows(in pickerView: CZPickerView!) -> Int { count }
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! { "Fruit \(row)" }
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        singleRow = row; events.append("single"); didConfirm?()
    }
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [Any]!) {
        multipleRows = rows as? [Int]; events.append("multiple"); didConfirm?()
    }
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) { events.append("cancel"); didCancel?() }
    func czpickerViewWillDisplay(_ pickerView: CZPickerView!) { events.append("willDisplay") }
    func czpickerViewDidDisplay(_ pickerView: CZPickerView!) { events.append("didDisplay"); didDisplay?() }
    func czpickerViewWillDismiss(_ pickerView: CZPickerView!) { events.append("willDismiss") }
    func czpickerViewDidDismiss(_ pickerView: CZPickerView!) { events.append("didDismiss") }
}
