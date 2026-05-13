# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Build**
```bash
swift build
```

**Run all tests**
```bash
swift test
```

**Run a single test**
```bash
swift test --filter AuthConfigurationTests/testEphemeralWebSessionDefaultsFalse
```

**Lint**
```bash
swiftlint
```

**Validate podspec**
```bash
pod lib lint WebAuthentication.podspec
```

**Publish a new version to CocoaPods** (after updating `s.version` in the podspec, committing, and tagging)
```bash
git tag <version>
git push origin <version>
pod trunk push WebAuthentication.podspec
```

## Architecture

This is a small iOS library with no external dependencies. It wraps `ASWebAuthenticationSession` to simplify OAuth/SSO flows.

**Public API surface (`Sources/`)**
- `AuthConfiguration` — value type (struct) holding all settings: callback URL scheme, token query param name, notification name/key, and ephemeral session flag.
- `WebAuthentication` — main entry point (class). Takes an `AuthConfiguration` and exposes `display(_:from:completion:)`. Delegates internally to `ASWebAuthenticator`.
- `WebAuthentication+SwiftUI` — extends `WebAuthentication` with a UIViewController-free overload, an `async/await` overload, and a `.webAuthentication(_:url:onResult:)` View Modifier for SwiftUI.
- `WebAuthenticationInterface` — protocol that both `WebAuthentication` and `ASWebAuthenticator` conform to. Defines `display(_:from:completion:)`.
- `WebAuthenticationResult` / `WebAuthenticationError` — enums for the completion result.

**Internal**
- `ASWebAuthenticator` — internal class that owns the `ASWebAuthenticationSession`. Not exposed publicly.

**Flow**
1. Caller creates `AuthConfiguration` and `WebAuthentication`.
2. Calls `display(_:from:)` (UIKit) or one of the SwiftUI overloads.
3. `WebAuthentication` instantiates `ASWebAuthenticator` and forwards the call.
4. `ASWebAuthenticator` starts the session. On callback, it extracts the token from the query params, posts a `NotificationCenter` notification, and calls the completion with `.success(.token)` or `.success(.otherCallback)`. On error it maps `ASWebAuthenticationSessionError` to `WebAuthenticationError`.

**Distribution**
- Swift Package Manager: `Package.swift` (minimum iOS 15, Swift 5.5)
- CocoaPods: `WebAuthentication.podspec` (current published version `0.2.0`)
