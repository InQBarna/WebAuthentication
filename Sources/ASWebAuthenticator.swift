//
//  ASWebAuthenticator.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import AuthenticationServices
import Foundation

/**
 ASWebAuthenticator uses ASWebAuthenticationSession from AuthenticationServices to share login state between the app and the mobile web browser. Available for iOS versions >= iOS 12.
 For older iOS versions a different implementation of the WebAuthentication protocol should be used.
 Once the deployment target is raised to iOS 12 we could just keep this protocol implementation.
 */
@available(iOS 12.0, *)
class ASWebAuthenticator: NSObject, WebAuthenticationInterface, ASWebAuthenticationPresentationContextProviding {
    private var authSession: ASWebAuthenticationSession?
    private weak var presenterVC: UIViewController?
    private var completionClosure: ((String?, WebAuthenticationError?) -> Void)?
    private var config: AuthConfiguration
    
    init(config: AuthConfiguration) {
        self.config = config
        super.init()
    }

    func display(_ url: URL, from vc: UIViewController, completion: @escaping ((String?, WebAuthenticationError?) -> Void)) {
        presenterVC = vc

        authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: config.authCallbackURLScheme) { callbackURL, error in
            guard error == nil,
                  let callbackURL = callbackURL else {
                self.postNotification(with: nil)
                
                var finalError: WebAuthenticationError?
                if let error = error as? ASWebAuthenticationSessionError {
                    switch error.code {
                    case .canceledLogin:
                        finalError = .userCancelled
                    default:
                        finalError = .error(error)
                    }
                }
                
                completion(nil, finalError)
                return
            }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            if let token = queryItems?.filter({ $0.name == self.config.authCallbackTokenQueryParamName }).first?.value {
                self.postNotification(with: token)
                completion(token, nil)
            } else {
                self.postNotification(with: nil)
                completion(nil, nil)
            }
        }

        if #available(iOS 13.0, *) {
            authSession?.presentationContextProvider = self
            authSession?.prefersEphemeralWebBrowserSession = self.config.ephemeralWebSession
        } else {
            // Fallback on earlier versions
        }
        authSession?.start()
    }

    private func postNotification(with token: String?) {
        let tokenString = token ?? ""
        NotificationCenter.default.post(
            name: config.authStatusChangedNotificationName,
            object: nil,
            userInfo: [config.authStatusChangedNotificationInfo: tokenString])
    }

    // MARK: ASWebAuthenticationPresentationContextProviding

    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return (presenterVC?.view.window ?? UIApplication.shared.delegate?.window ?? UIWindow())!
    }
}
