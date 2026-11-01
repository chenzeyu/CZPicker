# Objective-C compatibility library

This directory is part of the maintained CZPicker 1.x distribution. Its older source dates reflect a deliberate compatibility guarantee: the headers and implementation in `Classes/` are unchanged from 0.4.3.

- **Swift Package Manager:** select the `CZPicker` product.
- **CocoaPods:** use `CZPicker/Core` (also the default for `CZPicker`).
- **Minimum deployment target:** iOS 15. Minimum-OS runtime testing remains unverified; see [validation notes](../docs/VALIDATION.md).
- **Compatibility checks:** `scripts/check-legacy-api.sh` checks the original source hashes; `Tests/CZPickerTests/LegacyTests.swift` covers API behavior.

For the opt-in SwiftUI and UIKit interface, see [CZPickerUI](../Sources/CZPickerUI) and the [maintained showcase](../Examples/Showcase). See the [migration guide](../docs/MIGRATION.md) for original API usage and historical examples.
