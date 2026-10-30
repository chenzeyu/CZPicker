# Demo recording

The README GIF and MP4 are recordings of the real `Examples/Showcase` application, captured on an iPhone 17 simulator running iOS 26.5 on October 30, 2026. They show actual UIKit/SwiftUI rendering, keyboard interaction, search, selection changes, and sheet transitions.

`ShowcaseUITests.testReadmeWalkthrough` drives the interaction: open teammates, replace Maya with Amara, search for Noah, add him, confirm three teammates, then select Lisbon. Its assertions verify the resulting selections. The short pauses make the recording readable.

Capture with `xcrun simctl io <device-id> recordVideo --codec=h264 raw.mov` while running that test on the same device with `-parallel-testing-enabled NO`. Stop recording with SIGINT. Trim only the startup/teardown outside the app interaction, then encode an MP4 and looping GIF with FFmpeg. The committed clip plays at real speed; it has no fabricated interactions or composited UI.

The GIF is 360 pixels wide at 12 fps to keep the README lightweight. The MP4 is 640 pixels wide at 30 fps for a sharper, pausable alternative. Static PNGs remain available as non-animated previews.

FFmpeg is an optional documentation-authoring tool. It is not a dependency of the package, pod, demo app, or tests. Raw recordings and intermediate images are not shipped with the library.
