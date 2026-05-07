# WebAuthentication

[![Version](https://img.shields.io/cocoapods/v/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)
[![License](https://img.shields.io/cocoapods/l/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)
[![Platform](https://img.shields.io/cocoapods/p/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)

A simple library for web-based authentication (OAuth, SSO) on iOS. It presents a browser session, waits for the callback and extracts the token automatically.

## Requirements

- iOS 15+
- Swift 5.5+

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/InQBarna/WebAuthentication.git", from: "0.2.0")
```

### CocoaPods

```ruby
pod 'WebAuthentication'
```

## Usage

### 1. Create a configuration

```swift
let config = AuthConfiguration(
    authCallbackURLScheme: "myapp",
    authCallbackTokenQueryParamName: "token",
    authStatusChangedNotificationName: Notifications.authStatusChanged,
    authStatusChangedNotificationInfo: "tokenKey"
)
```

### 2. Create an instance

```swift
let auth = WebAuthentication(configuration: config)
```

### 3. Display the authentication flow

**UIKit**
```swift
auth.display(loginURL, from: viewController) { result in
    switch result {
    case .success(.token(let token)):
        // use token
    case .success(.otherCallback(let url)):
        // callback received without token
    case .failure(let error):
        // handle error
    }
}
```

**SwiftUI — callback**
```swift
auth.display(loginURL) { result in
    switch result {
    case .success(.token(let token)): // use token
    case .failure(let error): // handle error
    }
}
```

**SwiftUI — async/await**
```swift
let result = await auth.display(loginURL)
if case .success(.token(let token)) = result {
    // use token
}
```

**SwiftUI — View Modifier**
```swift
struct ContentView: View {
    @State private var authURL: URL? = nil

    var body: some View {
        Button("Login") {
            authURL = URL(string: "https://your-service.com/auth")!
        }
        .webAuthentication(auth, url: $authURL) { result in
            switch result {
            case .success(.token(let token)): // use token
            case .failure(let error): // handle error
            }
        }
    }
}
```

### Ephemeral session

Pass `ephemeralWebSession: true` to run the login in private mode — no cookies or credentials will be shared with the browser.

```swift
let config = AuthConfiguration(
    authCallbackURLScheme: "myapp",
    authCallbackTokenQueryParamName: "token",
    authStatusChangedNotificationName: Notifications.authStatusChanged,
    authStatusChangedNotificationInfo: "tokenKey",
    ephemeralWebSession: true
)
```

## Author

InQBarna, alexis.katsaprakakis@inqbarna.com

## License

WebAuthentication is available under the MIT license. See the LICENSE file for more info.
