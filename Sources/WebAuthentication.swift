//
//  WebAuthentication.swift
//  WebAuthentication
//
//  Created by Alexandros Katsaprakakis on 27/11/2020.
//

import UIKit

/**
 Displays a web environment for authenticating.
 
 - important:
    If your app supports a version older than iOS 12, you are responsible for handling the service callback and infering the token in AppDelegate's application(_: , open url:, options _: ) -> Bool method
 
 ----
 Switches protocol implementations depending on iOS version:
 * SafariWebVCAuthenticator for iOS 11 and below
 * ASWebAuthenticator for iOS 12 and above
 
 */
public class WebAuthentication: WebAuthenticationInterface {
    private var config: AuthConfiguration
    private var handler: WebAuthenticationInterface?
    private weak var presentingVC: UIViewController?
    
    public init(configuration: AuthConfiguration) {
        self.config = configuration
    }
    
    /// Displays the corresponding web environment and waits for the authentication completion
    ///
    ///
    /// - Parameters:
    ///   - url: authentication service url to load inside the corresponding web environment
    ///   - presenter: the viewController that will present the web environment
    ///   - completion: closure called with token value when obtained or nil if terminating without a token
    public func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((String?) -> Void)) {
        self.presentingVC = presenter
        
        if #available(iOS 12.0, *) {
            handler = ASWebAuthenticator(config: config)
        } else {
            handler = SafariWebVCAuthenticator(config: config)
        }

        handler?.display(url, from: presenter, completion: { token in
            if let safariAuth = self.handler as? SafariWebVCAuthenticator,
               self.presentingVC?.presentedViewController == safariAuth.safariVC {
                self.presentingVC?.dismiss(animated: true, completion: nil)
            }
            completion(token)
        })
    }
}
