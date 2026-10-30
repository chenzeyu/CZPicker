# Contributing

Keep CZPicker small, accessible, and free of external runtime dependencies.

1. Start with a focused issue or reproduction for behavior changes.
2. Keep the Objective-C API compatible or document an intentional migration.
3. Add a regression test for selection or lifecycle fixes.
4. Run package tests and the Showcase UI tests on an installed iOS simulator.
5. For UI changes, check light/dark appearance, large text, iPad layout, and VoiceOver. Include screenshots and describe what you actually tested.
6. Update examples and docs when changing the public API.

The maintained demo is `Examples/Showcase`. The old examples remain for history. Do not commit generated Pods, build outputs, credentials, or personal Xcode settings. Public APIs should solve demonstrated use cases; prefer native framework behavior over new dependencies or configuration layers.
