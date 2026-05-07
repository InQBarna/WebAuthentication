//
//  AuthConfiguration.swift
//  WebAuthentication
//
//  Created by Alexandros Katsaprakakis on 27/11/2020.
//

import Foundation

/// Configuration required to initialize a `WebAuthentication` instance.
public struct AuthConfiguration {
    /// URL scheme your app registers to receive the authentication callback (e.g. `"myapp"`).
    public let authCallbackURLScheme: String
    /// Name of the query parameter in the callback URL that contains the token (e.g. `"token"`).
    public let authCallbackTokenQueryParamName: String
    /// Name of the notification posted when authentication status changes.
    public let authStatusChangedNotificationName: Notification.Name
    /// Key used to store the token in the notification's `userInfo` dictionary.
    public let authStatusChangedNotificationInfo: String
    /// When `true`, the session runs in private mode — no cookies or credentials are shared with the browser. Defaults to `false`.
    public let ephemeralWebSession: Bool

    /// Creates a new configuration.
    ///
    /// - Parameters:
    ///   - authCallbackURLScheme: URL scheme registered in your app for the authentication callback.
    ///   - authCallbackTokenQueryParamName: query parameter name that carries the token in the callback URL.
    ///   - authStatusChangedNotificationName: notification posted when authentication completes.
    ///   - authStatusChangedNotificationInfo: key for the token value inside the notification's userInfo.
    ///   - ephemeralWebSession: pass `true` to prevent sharing session & credentials with the browser. Defaults to `false`.

    public init(authCallbackURLScheme: String,
                authCallbackTokenQueryParamName: String,
                authStatusChangedNotificationName: Notification.Name,
                authStatusChangedNotificationInfo: String,
                ephemeralWebSession: Bool = false) {
        self.authCallbackURLScheme = authCallbackURLScheme
        self.authCallbackTokenQueryParamName = authCallbackTokenQueryParamName
        self.authStatusChangedNotificationName = authStatusChangedNotificationName
        self.authStatusChangedNotificationInfo = authStatusChangedNotificationInfo
        self.ephemeralWebSession = ephemeralWebSession
    }
}
