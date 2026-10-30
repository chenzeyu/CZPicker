import SwiftUI
import UIKit

/// UIKit presentation of the same selection UI. Only Done invokes `onConfirm`.
@available(iOS 16.0, *)
@MainActor
public final class CZPickerViewController<ID: Hashable>: UIHostingController<CZPickerSheet<ID, CZPickerDefaultRow<ID>>> {
    public init(title: String, items: [CZPickerItem<ID>], selection: Set<ID> = [],
                mode: CZPickerSelectionMode = .multiple(),
                onConfirm: @escaping (Set<ID>) -> Void) {
        let sheet = CZPickerSheet(title, items: items, selection: .constant(selection), mode: mode,
                                  onConfirm: onConfirm)
        super.init(rootView: sheet)
        modalPresentationStyle = .pageSheet
        sheetPresentationController?.detents = [.medium(), .large()]
        sheetPresentationController?.prefersGrabberVisible = true
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) { fatalError("Use init(title:items:selection:mode:onConfirm:)") }
}
