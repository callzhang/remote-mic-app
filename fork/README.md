# T1 Remote for macOS

T1 Remote is a community fork of [SayAll](https://github.com/HD838A/remote-mic-app). Its source includes the T1 first-run setup, Bluetooth recovery, voice input and button mapping from [upstream PR #1220](https://github.com/HD838A/remote-mic-app/pull/1220).

- This release supports Apple Silicon Macs with macOS 14 or later. Download the ZIP, unzip it and drag `T1 Remote.app` to Applications.
- Quit another copy of SayAll before opening T1 Remote. The fork has its own app identity and settings. Open T1 Remote and choose T1 in the first-run setup. Allow Bluetooth, Input Monitoring and Accessibility when requested.
- For voice input, install the compatible `SayAll` virtual microphone if it is missing. The upstream [SayAll installer](https://github.com/HD838A/remote-mic-app/releases/tag/v2.0.10) provides it. Either `SayAll` or `MiRemoteV 2ch` may appear. Select the same device as the output in T1 Remote and as the microphone in your input tool. In WeChat Input, enable hold-to-talk.
- This test build has an ad-hoc signature and has not been notarized. macOS may prevent it from opening. See [Apple's guidance](https://support.apple.com/en-us/102445) if it displays an alert.

To reproduce the release, check out its tag and run `zsh fork/build-release.zsh` on macOS with a current Swift toolchain. The ZIP and its checksum are written to `dist/fork`. The virtual microphone is installed separately.

The macOS source is available under the [GPL-3.0-only license](../LICENSE.md). See [copyright](../COPYRIGHT.md) and [third-party notices](../THIRD_PARTY_NOTICES.md). The blue remote icons on this branch are original replacements for the upstream brand assets.
