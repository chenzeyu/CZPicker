import SwiftUI
import CZPickerUI
import CZPicker

@main
struct ShowcaseApp: App {
    var body: some Scene { WindowGroup {
        ShowcaseView().tint(Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.32, green: 0.85, blue: 0.72, alpha: 1)
                : UIColor(red: 0.04, green: 0.38, blue: 0.33, alpha: 1)
        }))
    } }
}

struct ShowcaseView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var active: Demo?
    @State private var teammates: Set<String> = ["maya", "leo"]
    @State private var destination: Set<String> = ["kyoto"]
    @State private var interests: Set<String> = ["design"]
    @State private var showUIKit = false
    enum Demo: String, Identifiable { case teammates, destination, interests; var id: String { rawValue } }

    static let people: [CZPickerItem<String>] = [
        .init(id: "maya", title: "Maya Chen", subtitle: "Product designer", section: "Design"),
        .init(id: "leo", title: "Leo Martin", subtitle: "Design engineer", section: "Design"),
        .init(id: "amara", title: "Amara Okafor", subtitle: "iOS engineer", section: "Engineering"),
        .init(id: "noah", title: "Noah Kim", subtitle: "Platform engineer", section: "Engineering"),
        .init(id: "sofia", title: "Sofia Rossi", subtitle: "On leave", section: "Engineering", isEnabled: false)
    ]
    static let destinations: [CZPickerItem<String>] = [
        .init(id: "kyoto", title: "Kyoto", subtitle: "Japan · Temples & quiet streets", symbol: "leaf", section: "Asia"),
        .init(id: "singapore", title: "Singapore", subtitle: "Singapore · A city in a garden", symbol: "building.2", section: "Asia"),
        .init(id: "lisbon", title: "Lisbon", subtitle: "Portugal · Hills & ocean air", symbol: "sun.max", section: "Europe"),
        .init(id: "copenhagen", title: "Copenhagen", subtitle: "Denmark · Design by the water", symbol: "bicycle", section: "Europe")
    ]
    static let topics: [CZPickerItem<String>] = [
        .init(id: "design", title: "Design", subtitle: "Make things feel right", symbol: "paintpalette", section: "Create"),
        .init(id: "code", title: "Engineering", subtitle: "Build something useful", symbol: "curlybraces", section: "Create"),
        .init(id: "photo", title: "Photography", symbol: "camera", section: "Explore"),
        .init(id: "travel", title: "Travel", symbol: "globe.europe.africa", section: "Explore"),
        .init(id: "music", title: "Music", subtitle: "Coming soon", symbol: "music.note", section: "Explore", isEnabled: false)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("SMALL LIBRARY. THOUGHTFUL DETAILS.", systemImage: "checkmark.circle.fill")
                            .font(.caption.weight(.bold)).foregroundStyle(.tint)
                        Text("Good choices.\nBeautifully simple.")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Text("Search, select, and make it yours.\nZero dependencies. All the essentials.")
                            .font(.body).foregroundStyle(.secondary)
                    }.padding(.top, 16)
                    VStack(spacing: 14) {
                        demoCard("Invite your team", subtitle: "Search · multiple selection · custom rows", symbol: "person.2", count: "\(teammates.count) selected", demo: .teammates)
                        demoCard("Find your next stop", subtitle: "Single selection · sections · subtitles", symbol: "globe.asia.australia", count: destination.first?.capitalized ?? "Choose a city", demo: .destination)
                        demoCard("Follow your curiosity", subtitle: "SF Symbols · disabled options", symbol: "sparkles", count: "\(interests.count) selected", demo: .interests)
                    }
                    HStack(spacing: 8) {
                        Label("SwiftUI + UIKit", systemImage: "square.stack.3d.up")
                        Spacer()
                        Text("SPM ready")
                    }.font(.caption.weight(.medium)).foregroundStyle(.secondary)
                    Button("Try the UIKit presenter") { showUIKit = true }
                        .font(.subheadline.weight(.semibold))
                        .accessibilityIdentifier("showcase.uikit")
                }.padding(24)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("CZPicker")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $active) { demo in
                switch demo {
                case .teammates:
                    CZPickerSheet("Invite teammates", items: Self.people, selection: $teammates,
                                  mode: .multiple(maximum: 3)) { person in
                        HStack(spacing: 12) {
                            if !dynamicTypeSize.isAccessibilitySize {
                            Text(person.title.split(separator: " ").compactMap(\.first).map(String.init).joined())
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.tint)
                                .frame(width: 42, height: 42)
                                .background(.tint.opacity(0.12), in: Circle())
                                .accessibilityHidden(true)
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(person.title).font(.body.weight(.medium))
                                Text(person.subtitle ?? "").font(.subheadline).foregroundStyle(.primary.opacity(0.75))
                            }
                        }
                    }
                case .destination:
                    CZPickerSheet("Your next destination", items: Self.destinations, selection: $destination, mode: .single)
                case .interests:
                    CZPickerSheet("Make it personal", items: Self.topics, selection: $interests)
                }
            }
            .sheet(isPresented: $showUIKit) { UIKitExample() }
            .onAppear {
                if let value = ProcessInfo.processInfo.environment["CZPICKER_DEMO"] {
                    active = Demo(rawValue: value)
                }
            }
        }
    }

    private func demoCard(_ title: String, subtitle: String, symbol: String, count: String, demo: Demo) -> some View {
        Button { active = demo } label: {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Image(systemName: symbol).font(.title2).foregroundStyle(.tint)
                    Spacer()
                    Image(systemName: "arrow.up.right").font(.subheadline.weight(.semibold)).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(.title3.weight(.semibold)).foregroundStyle(.primary)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Text(count).font(.caption.weight(.semibold)).foregroundStyle(.tint)
                    .accessibilityIdentifier("showcase.count.\(demo.rawValue)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("showcase.\(demo.rawValue)")
    }
}

struct UIKitExample: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { UIKitExampleController() }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

final class UIKitExampleController: UIViewController {
    private var selection: Set<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let button = UIButton(type: .system)
        button.setTitle("Choose a destination with UIKit", for: .normal)
        button.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.centerXAnchor), button.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    @objc private func showPicker() {
        let picker = CZPickerViewController(title: "UIKit, same experience", items: ShowcaseView.destinations,
                                            selection: selection, mode: .single) { [weak self] ids in self?.selection = ids }
        present(picker, animated: true)
    }
}
