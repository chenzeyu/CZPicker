import SwiftUI

/// Present inside `.sheet`. Selection is committed only by Done.
/// Use a fresh presentation when changing the selection mode.
@available(iOS 16.0, *)
public struct CZPickerSheet<ID: Hashable, Row: View>: View {
    private let title: String
    private let items: [CZPickerItem<ID>]
    private let mode: CZPickerSelectionMode
    private let searchable: Bool
    private let doneTitle: String
    private let cancelTitle: String
    private let searchPrompt: String
    private let onConfirm: ((Set<ID>) -> Void)?
    private let onCancel: (() -> Void)?
    private let row: (CZPickerItem<ID>) -> Row
    @Binding private var selection: Set<ID>
    @State private var draft: SelectionDraft<ID>
    @State private var query = ""
    @State private var detent: PresentationDetent = .large
    @Environment(\.dismiss) private var dismiss

    public init(_ title: String, items: [CZPickerItem<ID>], selection: Binding<Set<ID>>,
                mode: CZPickerSelectionMode = .multiple(), searchable: Bool = true,
                doneTitle: String = "Done", cancelTitle: String = "Cancel", searchPrompt: String = "Search",
                onConfirm: ((Set<ID>) -> Void)? = nil, onCancel: (() -> Void)? = nil,
                @ViewBuilder row: @escaping (CZPickerItem<ID>) -> Row) {
        self.title = title
        self.items = items
        self._selection = selection
        self.mode = mode
        self.searchable = searchable
        self.doneTitle = doneTitle
        self.cancelTitle = cancelTitle
        self.searchPrompt = searchPrompt
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        self.row = row
        self._draft = State(initialValue: SelectionDraft(selection: selection.wrappedValue,
                                                        orderedIDs: items.map(\.id), mode: mode))
    }

    // First occurrence wins for duplicate IDs, avoiding undefined ForEach identity behavior.
    private var uniqueItems: [CZPickerItem<ID>] {
        var seen = Set<ID>()
        return items.filter { seen.insert($0.id).inserted }
    }
    private var filteredItems: [CZPickerItem<ID>] {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return uniqueItems.filter {
            text.isEmpty || [$0.title, $0.subtitle ?? "", $0.section ?? ""].contains {
                $0.localizedStandardContains(text)
            }
        }
    }
    private var sections: [String?] {
        var result: [String?] = []
        for item in filteredItems where !result.contains(item.section) { result.append(item.section) }
        return result
    }
    private var selectedItems: [CZPickerItem<ID>] { uniqueItems.filter { draft.ids.contains($0.id) } }
    private var selectionSummary: String {
        if case .multiple(let maximum) = mode, let maximum {
            return "\(draft.ids.count) / \(max(0, maximum)) selected"
        }
        return "\(draft.ids.count) selected"
    }

    public var body: some View {
        NavigationStack {
            searchableContent
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large], selection: $detent)
        .presentationDragIndicator(.visible)
        .onChange(of: items.map(\.id)) { ids in
            draft.reconcile(draft.ids, orderedIDs: ids)
        }
    }

    @ViewBuilder private var searchableContent: some View {
        if searchable {
            content.searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always),
                               prompt: Text(searchPrompt))
        } else { content }
    }

    private var content: some View {
        VStack(spacing: 0) {
            if case .multiple = mode {
                VStack(alignment: .leading, spacing: 10) {
                    Text(selectionSummary)
                        .font(.subheadline.weight(.medium)).foregroundStyle(.primary.opacity(0.75))
                        .accessibilityIdentifier("czpicker.count")
                    if !selectedItems.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(selectedItems) { item in
                                    Button { draft.toggle(item.id, enabled: item.isEnabled) } label: {
                                        HStack(spacing: 6) {
                                            Text(item.title)
                                            if item.isEnabled { Image(systemName: "xmark.circle.fill") }
                                        }
                                        .font(.subheadline.weight(.medium))
                                        .padding(.horizontal, 12).padding(.vertical, 9)
                                        .background(.tint.opacity(0.1), in: Capsule())
                                    }
                                    .disabled(!item.isEnabled)
                                    .accessibilityLabel(item.isEnabled ? "Remove \(item.title)" : "\(item.title), selected")
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20).padding(.vertical, 12)
            }
            List {
                if filteredItems.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "magnifyingglass").font(.largeTitle)
                        Text(query.isEmpty ? "No options available" : "No results")
                            .font(.headline)
                        if !query.isEmpty { Text("Try another search.").font(.subheadline) }
                    }
                    .foregroundStyle(.primary.opacity(0.75))
                    .frame(maxWidth: .infinity).padding(.vertical, 36)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(sections, id: \.self) { section in
                        Section {
                            ForEach(filteredItems.filter { $0.section == section }) { item in
                                option(item)
                            }
                        } header: {
                            if let section { Text(section).foregroundStyle(.primary.opacity(0.75)) }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollDismissesKeyboard(.interactively)
            HStack(spacing: 12) {
                Button { onCancel?(); dismiss() } label: {
                    Text(cancelTitle).foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(uiColor: .systemBackground), in: Capsule())
                        .overlay(Capsule().strokeBorder(Color.primary.opacity(0.5), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("czpicker.cancel")
                Button {
                    draft.reconcile(draft.ids, orderedIDs: uniqueItems.map(\.id))
                    selection = draft.ids
                    onConfirm?(draft.ids)
                    dismiss()
                } label: {
                    Text(doneTitle).fontWeight(.semibold)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("czpicker.done")
            }
            .controlSize(.large)
            .padding(.horizontal, 20).padding(.vertical, 12)
            .background(.regularMaterial)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func option(_ item: CZPickerItem<ID>) -> some View {
        let selected = draft.ids.contains(item.id)
        let enabled = draft.canToggle(item.id, enabled: item.isEnabled)
        return Button { draft.toggle(item.id, enabled: item.isEnabled) } label: {
            HStack(spacing: 12) {
                row(item).frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selected ? Color.accentColor : Color.secondary.opacity(0.35))
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 5)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityAddTraits(selected ? .isSelected : [])
        .accessibilityIdentifier("czpicker.option.\(String(describing: item.id))")
    }
}

@available(iOS 16.0, *)
public struct CZPickerDefaultRow<ID: Hashable>: View {
    private let item: CZPickerItem<ID>
    public init(item: CZPickerItem<ID>) { self.item = item }
    public var body: some View {
        HStack(spacing: 12) {
            if let symbol = item.symbol {
                Image(systemName: symbol).font(.title3)
                    .foregroundStyle(.tint).frame(width: 32).accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title).font(.body).foregroundStyle(.primary)
                if let subtitle = item.subtitle {
                    Text(subtitle).font(.subheadline).foregroundStyle(.primary.opacity(0.75))
                }
            }
        }
    }
}

@available(iOS 16.0, *)
public extension CZPickerSheet where Row == CZPickerDefaultRow<ID> {
    init(_ title: String, items: [CZPickerItem<ID>], selection: Binding<Set<ID>>,
         mode: CZPickerSelectionMode = .multiple(), searchable: Bool = true,
         doneTitle: String = "Done", cancelTitle: String = "Cancel", searchPrompt: String = "Search",
         onConfirm: ((Set<ID>) -> Void)? = nil, onCancel: (() -> Void)? = nil) {
        self.init(title, items: items, selection: selection, mode: mode, searchable: searchable,
                  doneTitle: doneTitle, cancelTitle: cancelTitle, searchPrompt: searchPrompt,
                  onConfirm: onConfirm, onCancel: onCancel) { CZPickerDefaultRow(item: $0) }
    }
}
