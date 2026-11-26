# SayAll for macOS with T1 support

This community build is based on [SayAll](https://github.com/HD838A/remote-mic-app). Its source includes the T1 first-run setup, Bluetooth recovery, voice input and button mapping from [upstream PR #1220](https://github.com/HD838A/remote-mic-app/pull/1220).

- This release supports Apple Silicon Macs with macOS 14 or later. Download the ZIP, unzip it and drag `SayAll.app` to Applications. Keep a copy of any existing SayAll.app before replacing it.
- Quit any running copy before opening this build of SayAll. The community build uses separate settings from the upstream app. Open SayAll and choose T1 in the first-run setup. Allow Bluetooth, Input Monitoring and Accessibility when requested.
- For voice input, install the compatible `SayAll` virtual microphone if it is missing. The upstream [SayAll installer](https://github.com/HD838A/remote-mic-app/releases/tag/v2.0.10) provides it. Either `SayAll` or `MiRemoteV 2ch` may appear. Select the same device as the output in SayAll and as the microphone in your input tool. In WeChat Input, enable hold-to-talk.
- This test build has an ad-hoc signature and has not been notarized. macOS may prevent it from opening. See [Apple's guidance](https://support.apple.com/en-us/102445) if it displays an alert.

To reproduce the release, check out its tag and run `zsh fork/build-release.zsh` on macOS with a current Swift toolchain. The ZIP and its checksum are written to `dist/fork`. The virtual microphone is installed separately.

The macOS source is available under the [GPL-3.0-only license](../LICENSE.md). See [copyright](../COPYRIGHT.md) and [third-party notices](../THIRD_PARTY_NOTICES.md). The blue remote icons on this branch are original replacements for the upstream brand assets.
