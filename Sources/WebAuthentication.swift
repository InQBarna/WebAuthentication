//
//  WebAuthentication.swift
//  WebAuthentication
//
//  Created by Alexandros Katsaprakakis on 27/11/2020.
//

import UIKit

/**
 Displays a web environment for authenticating.
 */
public class WebAuthentication: WebAuthenticationInterface {
    private var config: AuthConfiguration
    private var handler: WebAuthenticationInterface?

    public init(configuration: AuthConfiguration) {
        self.config = configuration
    }

    /// Displays the web authentication flow and waits for completion.
    ///
    /// - Parameters:
    ///   - url: authentication URL to load
    ///   - presenter: view controller that presents the web session
    ///   - completion: called with the token or an error when the flow ends
    public func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((Result<WebAuthenticationResult, WebAuthenticationError>) -> Void)) {
        let authenticator = ASWebAuthenticator(config: config)
        handler = authenticator
        authenticator.display(url, from: presenter, completion: completion)
    }
}
