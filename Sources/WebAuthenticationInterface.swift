//
//  WebAuthenticationInterface.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import UIKit

/// Errors that can occur during the web authentication flow.
public enum WebAuthenticationError: Error {
    /// The user closed the login screen without completing authentication.
    case userCancelled
    /// The authentication session could not be presented.
    case presentationError
    /// An error was returned by the underlying authentication session.
    case webAuthenticationError(Error)
    /// An unexpected error occurred.
    case unknownError
}

/// The result of a successful web authentication flow.
public enum WebAuthenticationResult {
    /// Authentication completed and a token was extracted from the callback URL.
    case token(String)
    /// A callback was received but it did not contain the expected token parameter.
    case otherCallback(URL)
}

/// Defines the interface for presenting a web authentication flow.
public protocol WebAuthenticationInterface {
    func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((Result<WebAuthenticationResult, WebAuthenticationError>) -> Void))
}
