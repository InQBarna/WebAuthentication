//
//  AuthConfiguration.swift
//  WebAuthentication
//
//  Created by Alexandros Katsaprakakis on 27/11/2020.
//

import Foundation

/// Configuration struct needed for initiliazing an WebAuthentication instance.
public struct AuthConfiguration {
    public let authCallbackURLScheme: String
    public let authCallbackTokenQueryParamName: String
    public let authStatusChangedNotificationName: Notification.Name
    public let authStatusChangedNotificationInfo: String
    public let ephemeralWebSession: Bool
    
    /// - Parameters:
    ///   - authCallbackURLScheme: url scheme for callback returning token once the authentication process is terminated
    ///   - authCallbackTokenQueryParamName: name for query parameter containing token as value in callback received when the authentication is finished
    ///   - authStatusChangedNotificationName: name for notification posted once the token is obtained
    ///   - authStatusChangedNotificationInfo: name for parameter inside userInfo of notification posted once the token is obtained
    ///   - ephemeralWebSession: applies to iOS > = 12. Setting it to true will prevent sharing session & credentials between the web & app
    
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
