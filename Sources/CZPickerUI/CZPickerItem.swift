import Foundation

/// A lightweight default row. IDs must be unique and stable across filtering and reloads.
public struct CZPickerItem<ID: Hashable>: Identifiable {
    public let id: ID
    public var title: String
    public var subtitle: String?
    public var symbol: String?
    public var section: String?
    public var isEnabled: Bool

    public init(id: ID, title: String, subtitle: String? = nil, symbol: String? = nil,
                section: String? = nil, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.section = section
        self.isEnabled = isEnabled
    }
}

/// Multiple selection can be unlimited or constrained. A negative limit behaves as zero.
public enum CZPickerSelectionMode: Equatable {
    case single
    case multiple(maximum: Int? = nil)

    var limit: Int? {
        switch self {
        case .single: return 1
        case .multiple(let maximum): return maximum.map { max(0, $0) }
        }
    }
}

// Value semantics keep edits local until the caller explicitly commits.
struct SelectionDraft<ID: Hashable> {
    private(set) var ids: Set<ID>
    let mode: CZPickerSelectionMode

    init(selection: Set<ID>, orderedIDs: [ID], mode: CZPickerSelectionMode) {
        self.mode = mode
        self.ids = []
        reconcile(selection, orderedIDs: orderedIDs)
    }

    mutating func reconcile(_ selection: Set<ID>, orderedIDs: [ID]) {
        var seen = Set<ID>()
        let valid = orderedIDs.filter { selection.contains($0) && seen.insert($0).inserted }
        ids = Set(mode.limit.map { Array(valid.prefix($0)) } ?? valid)
    }

    func canToggle(_ id: ID, enabled: Bool) -> Bool {
        guard enabled else { return false }
        if ids.contains(id) || mode == .single { return true }
        return mode.limit.map { ids.count < $0 } ?? true
    }

    mutating func toggle(_ id: ID, enabled: Bool) {
        guard canToggle(id, enabled: enabled) else { return }
        if ids.contains(id) { ids.remove(id) }
        else if mode == .single { ids = [id] }
        else { ids.insert(id) }
    }
}
