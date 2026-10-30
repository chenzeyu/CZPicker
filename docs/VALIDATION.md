# Validation

This is an unreleased implementation, not a claim of production adoption.

## Local environment

- Xcode 27.1, iOS 27.1 SDK; iOS 26.5 simulator runtime.
- iPhone 17 Pro for automated interaction tests; iPhone 17 for README captures.
- iPad Pro 11-inch (M5) for search/confirmation and UIKit interaction checks.

## Checks

- Package regression suite: 11 tests covering stable selection identity, cancellation isolation, limits, disabled items, deterministic normalization, reload pruning, repeated legacy presentation, dismiss/reuse, weak ownership, and attributed-title precedence.
- iPhone showcase suite: search with selections retained, maximum count, Cancel, Done, interactive-dismissal cancellation, single selection, and UIKit presentation.
- iPad showcase suite: search/confirmation/cancellation and UIKit presentation.
- Both SPM products compile as dependencies of the showcase, including a generic iOS device build with signing disabled.
- `swift package dump-package` reports an empty dependencies array.
- Both CocoaPods subspecs pass `pod lib lint` without allowing warnings.
- README images are actual simulator captures, not mockups.
- Dark appearance and the largest accessibility text size were visually inspected on iPhone. The demo hides decorative avatars at accessibility sizes and uses an adaptive accent. This is not a full accessibility audit.

## Review findings addressed

- Replaced the old root Pods-project shortcut, which prevented Xcode from discovering package schemes.
- Raised the compatibility target to iOS 15 after the installed SDK rejected iOS 13.
- Marked legacy delegate/data-source protocols as main-actor UI APIs for Swift callers.
- Moved Done out of the navigation bar after a UI test demonstrated that active search hid it.
- Kept confirmation in the main layout after screenshot review exposed a clipped single-selection footer with a search/safe-area-inset combination.
- Removed obsolete Travis configuration and made pre-release installation instructions explicit.

## Still required before a stable release

- Runtime testing on the minimum supported OS versions (iOS 15 legacy / iOS 16 modern).
- Physical-device testing and manual VoiceOver, right-to-left, keyboard, and accessibility review.
- The complete historical Objective-C demo is not modernized; `Examples/Showcase` is the maintained consumer.
- Built-in status/empty-state strings are currently English. Action/search labels are customizable; full localization is future work.
- GitHub Actions results must be checked after pushing; local passes do not establish hosted CI success.
- No release tag, CocoaPods publication, package-index submission, or community announcement has been made.

Xcode emitted its App Intents metadata note for targets that do not use App Intents; it does not indicate a missing CZPicker dependency.
