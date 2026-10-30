# Migration from 0.4.3

The modern SwiftUI API is additive. Existing Objective-C selectors remain in the `CZPicker` product; `CZPickerUI` is a separate SPM product. CocoaPods exposes the same sources as `Core` and `SwiftUI` subspecs under the `CZPicker` module.

## Compatibility changes

- Legacy minimum deployment target is now iOS 15; modern UI requires iOS 16. Keep 0.4.3 if older systems are a requirement.
- Delegate and data source are now weak. Keep a strong reference to any separate adapter object yourself.
- `show` only presents when there is exactly one foreground key window. For multi-window apps, always use `showInContainer:` with the intended view.
- Invalid, fractional, duplicate, and out-of-range row selections are discarded. Single-selection mode retains only the first valid row.
- `reloadData` prunes selections outside the new row count. Legacy selection is still row-based, so update selections yourself when reordering data.
- Attributed titles consistently take priority over plain titles, including rows with images.
- Layout follows the container and safe area. Default colors are adaptive, rows use scalable text, and animation respects Reduce Motion.
- Repeated `show` while visible is ignored. A picker can be dismissed and shown again without accumulating views.
- `dismiss` is public and dismisses without confirming or calling the cancel-button callback.
- Legacy cancellation keeps the existing in-memory row selection, as before. Transactional Cancel/Done behavior belongs to the modern API.

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

Continue implementing `numberOfRowsInPickerView:`, a title method, and the relevant confirmation delegate. The old `Example/` and `swift_demo/` directories are historical examples; use `Examples/Showcase/` for the maintained app.

## Moving to the modern API

Replace row numbers with stable model IDs. Pass `[CZPickerItem<ID>]` and a `Set<ID>` selection. Use `CZPickerSheet` from SwiftUI or `CZPickerViewController` from UIKit. Custom rows are SwiftUI views. The host application remains responsible for fetching data and persisting confirmed choices.
