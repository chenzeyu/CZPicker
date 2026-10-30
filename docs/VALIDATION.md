# Release validation — 1.0.0

These notes distinguish checks actually performed from unverified coverage. They are not a claim that every app, OS version, or accessibility configuration has been tested.

## Environment and checks

- Xcode 27.1 / iOS 27.1 SDK; iOS 26.5 simulators.
- 12 package regression tests pass: six modern selection tests and six original API contract tests.
- iPhone 17: seven showcase tests cover search, limits, Cancel, Done, swipe dismissal, UIKit, the recorded walkthrough, largest text, RTL, and an accessibility audit. The scoped iPhone audit also passes in dark appearance.
- iPad Pro 11-inch (M5): four interaction tests cover search/confirmation/cancellation, UIKit presentation, largest text, and RTL.
- Both CocoaPods subspecs pass local lint without allowing warnings; the unsigned generic iOS device build passes.
- The unchanged original Objective-C example controller compiled against the preserved header during the beta review.
- `scripts/check-legacy-api.sh` verifies the original source/header hashes against 0.4.3. The package dependency array is empty.

## Accessibility findings and scope

The iPhone system audit found low-contrast secondary text and accent colors, which were improved. Cancel moved from the navigation bar to a scalable footer next to Done, with an explicit high-contrast secondary button. Done uses an appearance-adaptive foreground for the showcase’s dark-mode accent. Disabled rows no longer receive extra opacity on top of native disabled styling.

The iPhone audit excludes only contrast reports on the three labels belonging to the known disabled Sofia fixture. Inactive controls are exempt from contrast requirements; no enabled control is excluded. See [WCAG contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html#inactive-user-interface-components).

Largest-text tests check that Cancel and Done remain hittable and within the screen. RTL tests verify selection and confirmation under an Arabic locale; they do not establish complete Arabic localization. Search tests exercise on-screen keyboard input.

A separate full-screen iPad audit reported elements without accessible identities, including contrast/text-detection findings while a sheet overlays the dimmed showcase. That audit is not recorded as passing. Manual inspection and assistive-technology testing remain needed; automated checks do not establish full accessibility compliance.

## Unverified coverage and known limitations

- Minimum-OS runtime testing (iOS 15 legacy / iOS 16 modern): not performed. Only iOS 26 runtimes are installed; Xcode reported iOS 15.5 and 16.4 unavailable for download. The maintainer explicitly accepted proceeding without these runtime checks. Deployment-target compilation is not proof of runtime compatibility.
- Physical-device testing: not performed. The paired iPhone could not be reached. A generic device build is not a device test.
- Manual VoiceOver, hardware-keyboard navigation, Reduce Motion, and a complete accessibility review remain unverified.
- Some built-in status and empty-state strings are English. Action and search labels are customizable.
- Original API behavior is frozen, including its historical limitations. The old demo projects are historical; `Examples/Showcase` is maintained.
- Hosted CI is not active. The available OAuth token lacks workflow scope; `docs/ci/github-actions.yml` is a template, not a successful hosted run.
- CocoaPods Trunk requires maintainer authentication. The Git-tag installation uses the same validated source.

## Media

README screenshots and animation are real simulator captures. See [recording provenance](MEDIA.md). Demo images are not bundled with either library product.
