# BannerHub

Rebuild pipeline for Gamehub 5.3.5 (ReVanced) using apktool.

## How it works

1. The original APK is stored as a GitHub Release asset under the `base-apk` tag.
2. The workflow downloads it, decompiles with apktool, applies any files in `patches/`, rebuilds, and signs.
3. The rebuilt APK is uploaded as a release asset.

## Making modifications

Place modified smali or resource files in the `patches/` directory, mirroring the apktool output structure. For example:

```
patches/
  smali/com/example/SomeClass.smali     ← replaces this file after decompile
  res/values/strings.xml                ← replaces this file after decompile
```

## Triggering a build

- Push a tag: `git tag v1.0.0 && git push refs/tags/v1.0.0`
- Or use **Actions → Build APK → Run workflow**

## Signing

Builds are signed with the committed `keystore.jks` (debug key, not for production distribution).
- Alias: `bannerhub`
- Store/key password: `bannerhub123`
