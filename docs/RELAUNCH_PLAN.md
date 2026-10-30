# CZPicker relaunch plan

## Product

Beautiful selection sheets for SwiftUI and UIKit, with zero external runtime dependencies. Preserve the repository and Objective-C API; make the modern API the primary onboarding experience.

## Architecture review

- Keep `CZPicker` as the Objective-C compatibility product (iOS 15+).
- Add `CZPickerUI`, an iOS 16+ SwiftUI interface with a UIKit hosting-controller entry point. One modern rendering implementation avoids duplicate UI maintenance.
- SPM exports both products; CocoaPods subspecs use the exact same source files. The default pod remains the legacy product to avoid surprising existing consumers.
- Use stable `Hashable` IDs and a small selection model shared by all modern presentation paths. Selection is a draft until Done; Cancel and interactive dismissal leave the caller's value unchanged.
- No external packages, image loaders, analytics, networking, or bundled demo resources. The host app owns remote data and images.
- Accessibility uses native controls, scalable text, semantic colors, and system sheet transitions. Manual VoiceOver testing remains a release gate.

## Implementation sequence and gates

1. Add packaging while freezing the legacy public header and implementation to release 0.4.3. Preserve ownership, selection semantics, appearance, and callbacks; test them explicitly. Raising the minimum OS is allowed.
2. Implement searchable single/multiple selection, selected chips, optional limits, disabled options, default/custom rows, and sections. Test selection identity, cancellation, limits, removal, and data refresh.
3. Build destination, teammate, and interest demos in a checked-in Xcode app with no generator required. Compile both SwiftUI and UIKit usage.
4. Add simulator tests for modern state and legacy regressions, device/simulator build checks, CocoaPods lint, and CI. Record actual simulator interactions for a README GIF/MP4, with still images as secondary references.
5. Rewrite README around a real visual, exact installation instructions, a complete minimal example, UIKit usage, supported versions, and migration notes. Keep unreleased status explicit; do not advertise an unavailable release tag.
6. Review the diff for API clarity, dependency creep, selection edge cases, lifecycle races, accessibility, and documentation accuracy. Fix findings and repeat relevant checks.

## Scope decisions

Ship search, single/multiple selection, preselection, optional maximum count, disabled options, adaptive styling, customizable rows, UIKit integration, and SPM/CocoaPods packaging. Defer remote search, pagination, tree selection, custom animation engines, and other platforms.

## Launch preparation

Prepare release notes and a credible README. After release approval: publish a version tag and pod, submit to Swift Package Index, and share a short demonstration and the revival story. Public posting and release publication are separate from implementation.

## Success criteria

- Clean consumer builds for both SPM products; zero package dependencies.
- CocoaPods subspecs lint/build using the same sources.
- Regression tests pass on a simulator; showcase builds for device and simulator.
- An actual simulator recording demonstrates search and selection in the implemented UI.
- No claimed device, accessibility, platform, or release validation without evidence.
- Track adoption, issue quality, and external contributions alongside stars after launch.

## Release checklist (historical planning gates)

- [ ] Minimum-supported-OS runtime pass: unavailable locally; maintainer accepted proceeding without it.
- [ ] Physical-device and manual assistive-technology checks remain unverified. Automated large-text and RTL interaction checks passed.
- [ ] Confirm final API/version and publish a release tag and pod.
- [x] Replace branch installation instructions with version 1.0.0.
- [ ] Submit to Swift Package Index and review launch posts.

## Implementation review outcome

The final design uses one modern SwiftUI interface for both SwiftUI and UIKit callers and keeps the Objective-C interface separate. The legacy minimum is iOS 15, adjusted after actual SDK validation. Package and pod distributions share sources and introduce no external runtime dependencies. The showcase and README use real simulator images. Search confirmation and footer layout issues found during validation were fixed before review handoff. Remaining release gates are documented in VALIDATION.md; publishing a stable version is intentionally separate from this implementation.

Publication constraint: the authenticated owner token can push code but lacks GitHub workflow scope. The reviewed CI definition is supplied at `docs/ci/github-actions.yml`; activating it requires copying it to `.github/workflows/ci.yml` with an appropriately authorized login. Local validation is complete independently of hosted CI.

Compatibility review refinement: the Objective-C source/header are restored exactly to 0.4.3. Earlier proposed weak ownership, callback, selection, and appearance changes are not part of the final implementation. New behavior is opt-in through CZPickerUI. The higher minimum OS remains intentional.
