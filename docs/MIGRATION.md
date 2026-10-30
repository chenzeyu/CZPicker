# Compatibility and adoption

The relaunch is additive: existing applications keep using `CZPickerView`; new applications can opt into `CZPickerUI`.

## Existing integrations

The Objective-C sources and public header in `Pod/Classes/` are byte-for-byte identical to release **0.4.3**. That preserves:

- Class names, initializer, methods, properties, data-source and delegate selectors.
- Delegate/data-source ownership and callback ordering.
- Selection ordering, preselection, `reloadData`, and cancellation semantics.
- Default appearance, animations, footer behavior, and customization properties.

The default `pod 'CZPicker'` still selects the Objective-C implementation, through the `Core` subspec. No SwiftUI dependency is added to that product. SPM exposes it as `CZPicker` with the same import name.

**The deployment requirement does change:** the preview requires iOS 15+ for `CZPicker`, and iOS 16+ for `CZPickerUI`. SPM requires Swift tools 5.9 / Xcode 15+. Apps may need to raise their deployment target; they do not need to rewrite their existing picker integration.

The compatibility product intentionally retains 0.4.3's limitations, including its application-delegate window lookup and row-based selection. This update does not silently change those behaviors. Use the existing `showInContainer:` method when an explicit host view is appropriate. Modern search, adaptive presentation, stable IDs, and draft selection are offered by the separate modern API.

Run `scripts/check-legacy-api.sh` to verify the frozen source checksums. The reference hashes in `docs/legacy-source.sha256` are from the 0.4.3 tag. Compatibility tests exercise defaults, ownership, selection ordering, reload/cancel behavior, confirmation, and lifecycle callbacks. These checks do not guarantee every historical app on every OS; minimum-OS and physical-device testing remain release gates.

## Existing Objective-C usage

```objc
@import CZPicker;

CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits"
                                            cancelButtonTitle:@"Cancel"
                                           confirmButtonTitle:@"Confirm"];
picker.delegate = self;
picker.dataSource = self;
picker.allowMultipleSelection = YES;
[picker setSelectedRows:@[@0]];
[picker showInContainer:self.view];
```

Continue implementing `numberOfRowsInPickerView:`, a title method, and the relevant confirmation delegate. No new dismiss method or actor annotation is introduced into the legacy public header.

## Optional modern API

Replace row numbers with stable model IDs when you choose to adopt the new UI. Pass `[CZPickerItem<ID>]` and a `Set<ID>` selection. Use `CZPickerSheet` from SwiftUI or `CZPickerViewController` from UIKit. Its draft selection commits only on Done; Cancel and interactive dismissal leave the caller's selection unchanged. These are modern API semantics, not changes to the legacy API.

The old `Example/` and `swift_demo/` directories are historical examples. `Examples/Showcase/` is the maintained modern demo.
