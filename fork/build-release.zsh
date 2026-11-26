#!/bin/zsh
set -euo pipefail

root=${0:A:h:h}
source_commit=$(git -C "$root" rev-parse HEAD)
[[ -z "$(git -C "$root" status --porcelain)" ]] || {
  print -u2 'Commit the fork release source before building.'
  exit 1
}

output="$root/dist/fork"
mkdir -p "$output"
stage=$(mktemp -d "${TMPDIR:-/private/tmp}/t1-remote-release.XXXXXX")
trap 'rm -rf "$stage"' EXIT

for variant in apple-silicon intel; do
  if [[ "$variant" == apple-silicon ]]; then
    architecture=arm64
    label=AppleSilicon
    app="$root/dist/SayAll.app"
    icon="$root/Resources/AppIcon.icns"
  else
    architecture=x86_64
    label=Intel
    app="$root/dist/intel/SayAll.app"
    icon="$root/Resources/AppIcon-intel.icns"
  fi

  RELEASE_VARIANT="$variant" CONFIGURATION="${CONFIGURATION:-release}" \
    SAYALL_BUILD_CHANNEL=public SAYALL_PRIVATE_PLATFORM_MODE=public \
    CODE_SIGN_IDENTITY=- REMOTE_MIC_SENTRY_DSN= SAYALL_CLIENT_PROOF_KEY= \
    /bin/zsh "$root/scripts/build-app.sh"

  plist="$app/Contents/Info.plist"
  test "$(plutil -extract CFBundleIdentifier raw -o - "$plist")" = io.github.callzhang.t1remote
  test "$(plutil -extract SayAllSourceCommit raw -o - "$plist")" = "$source_commit"
  test "$(plutil -extract SayAllPrivateArtifactsIncluded raw -o - "$plist")" = false
  test "$(plutil -extract SUEnableAutomaticChecks raw -o - "$plist")" = false
  if plutil -extract SUFeedURL raw -o - "$plist" >/dev/null 2>&1; then
    print -u2 'The fork must not contain the upstream update feed.'
    exit 1
  fi
  test "$(lipo -archs "$app/Contents/MacOS/RemoteMic")" = "$architecture"
  cmp "$icon" "$app/Contents/Resources/AppIcon.icns"
  "$root/scripts/verify-localizations.sh" "$app"/Contents/Resources/*.lproj
  codesign --verify --strict --deep "$app"

  version=$(plutil -extract CFBundleShortVersionString raw -o - "$plist")
  build=$(plutil -extract CFBundleVersion raw -o - "$plist")
  payload="$stage/$label"
  mkdir -p "$payload"
  ditto --norsrc --noextattr --noqtn --noacl "$app" "$payload/T1 Remote.app"
  cp "$root"/{LICENSE.md,COPYRIGHT.md,THIRD_PARTY_NOTICES.md} "$payload/"
  archive="T1-Remote-$version-$build-$label.zip"
  ditto --norsrc --noextattr --noqtn --noacl -c -k "$payload" "$stage/$archive"
  unzip -tq "$stage/$archive"
  mv "$stage/$archive" "$output/$archive"
done

cd "$output"
shasum -a 256 T1-Remote-"$version-$build"-{AppleSilicon,Intel}.zip > SHA256SUMS.txt
