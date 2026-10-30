import XCTest
import UIKit
import CZPicker

@MainActor
final class LegacyTests: XCTestCase, CZPickerViewDataSource {
    var count = 3
    func numberOfRows(in pickerView: CZPickerView!) -> Int { count }
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! { "Plain" }
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        NSAttributedString(string: "Attributed")
    }
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! { UIImage(systemName: "star") }
    func picker() -> CZPickerView {
        let picker = CZPickerView(headerTitle: "Test", cancelButtonTitle: "Cancel", confirmButtonTitle: "Done")!
        picker.animationDuration = 0
        picker.dataSource = self
        return picker
    }
    func testSelectionDeduplicatesAndReloadPrunes() {
        let picker = picker()
        picker.allowMultipleSelection = true
        picker.setSelectedRows([0, 0, 2, -1, 10, 1.5])
        XCTAssertEqual(picker.selectedRows() as? [Int], [0, 2])
        count = 1
        picker.reloadData()
        XCTAssertEqual(picker.selectedRows() as? [Int], [0])
    }
    func testPresentationUsesContainerBoundsAndRepeatedShowIsIdempotent() {
        let host = UIView(frame: CGRect(x: 50, y: 80, width: 320, height: 480))
        let picker = picker()
        picker.show(inContainer: host)
        XCTAssertEqual(picker.frame, host.bounds)
        picker.show(inContainer: host)
        XCTAssertEqual(picker.subviews.count, 2)
        XCTAssertEqual(host.subviews.count, 1)
    }
    func testAttributedTitleWinsEvenWithImages() {
        let picker = picker()
        let table = UITableView()
        let cell = picker.tableView(table, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.attributedText?.string, "Attributed")
    }
    func testDismissAndReuseDoesNotAccumulateContainers() async {
        let host = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let picker = picker()
        picker.show(inContainer: host)
        picker.dismiss()
        let dismissed = expectation(description: "Dismissal completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismissed.fulfill() }
        await fulfillment(of: [dismissed], timeout: 2)
        XCTAssertNil(picker.superview)
        picker.show(inContainer: host)
        XCTAssertEqual(picker.subviews.count, 2)
        XCTAssertEqual(host.subviews.count, 1)
    }

    func testDelegateAndDataSourceDoNotRetainOwner() {
        let picker = picker()
        autoreleasepool {
            let source = TemporarySource()
            picker.dataSource = source
        }
        XCTAssertNil(picker.dataSource)
    }
}
@MainActor
private final class TemporarySource: NSObject, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int { 0 }
}
