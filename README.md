# WebAuthentication

[![Version](https://img.shields.io/cocoapods/v/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)
[![License](https://img.shields.io/cocoapods/l/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)
[![Platform](https://img.shields.io/cocoapods/p/WebAuthentication.svg?style=flat)](https://cocoapods.org/pods/WebAuthentication)

## Installation

* SPM
* Cocoapods: 
```ruby
pod 'WebAuthentication'
```

## Usage 

Create an AuthConfiguration instance with the corresponding parameters:
```swift
let config = AuthConfiguration(
    authCallbackURLScheme: ProfileConstants.authURLScheme,
    authCallbackTokenQueryParamName: ProfileConstants.authTokenQueryName,
    authStatusChangedNotificationName: Notifications.authStatusChanged,
    authStatusChangedNotificationInfo: ProfileConstants.authTokenQueryName)
```    
Use it to instantiate a WebAuthentication :
```swift
let authenticator = WebAuthentication(configuration: authConfig)
```

Call display method passing a UIViewController that will act as the presenter of the login process
```swift
authenticator?.display(url, from: viewController!, completion: { _ })
```
**Important:**
   If your app supports an older version of iOS 12, you are responsible for handling the service callback and infering the token in AppDelegate's: 
   ```swift
   application(_: , open url:, options _: ) -> Bool 
  ``` 

## Author

catchakos, alexis.katsaprakakis@inqbarna.com

## License

WebAuthentication is available under the MIT license. See the LICENSE file for more info.
