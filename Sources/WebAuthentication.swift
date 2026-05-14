//
//  WebAuthentication.swift
//  WebAuthentication
//
//  Created by Alexandros Katsaprakakis on 27/11/2020.
//

import UIKit

/**
 Main entry point for web-based authentication.

 Presents a browser session where the user can log in, then extracts
 the token from the callback URL and delivers it via completion closure.

 ```swift
 let auth = WebAuthentication(configuration: config)
 auth.display(loginURL, from: viewController) { result in
     switch result {
     case .success(.token(let token)): // use token
     case .failure(let error): // handle error
     }
 }
 ```
 */
public class WebAuthentication: WebAuthenticationInterface {
    private var config: AuthConfiguration
    private var handler: WebAuthenticationInterface?

    /// Creates a new instance with the given configuration.
    /// - Parameter configuration: settings needed to run the authentication flow.
    public init(configuration: AuthConfiguration) {
        self.config = configuration
    }

    /// Displays the web authentication flow and waits for completion.
    ///
    /// - Parameters:
    ///   - url: authentication URL to load
    ///   - presenter: view controller that presents the web session
    ///   - completion: called with the token or an error when the flow ends
    public func display(_ url: URL, from presenter: UIViewController,
                        completion: @escaping ((Result<WebAuthenticationResult, WebAuthenticationError>) -> Void)) {
        let authenticator = ASWebAuthenticator(config: config)
        handler = authenticator
        authenticator.display(url, from: presenter, completion: completion)
    }
}
