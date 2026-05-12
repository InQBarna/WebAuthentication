//
//  ASWebAuthenticator.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import AuthenticationServices
import UIKit

/**
 ASWebAuthenticator uses ASWebAuthenticationSession from AuthenticationServices to share login state between the app and the mobile web browser.
 */
class ASWebAuthenticator: NSObject, WebAuthenticationInterface, ASWebAuthenticationPresentationContextProviding {
    private var authSession: ASWebAuthenticationSession?
    private weak var presenterVC: UIViewController?
    private var config: AuthConfiguration

    init(config: AuthConfiguration) {
        self.config = config
        super.init()
    }

    func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((Result<WebAuthenticationResult, WebAuthenticationError>) -> Void)) {
        presenterVC = presenter

        authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: config.authCallbackURLScheme) { [weak self] callbackURL, error in
            guard let self else { return }
            guard error == nil, let callbackURL = callbackURL else {
                self.postNotification(with: nil)

                let finalError: WebAuthenticationError
                if let error = error as? ASWebAuthenticationSessionError {
                    switch error.code {
                    case .canceledLogin:
                        finalError = .userCancelled
                    case .presentationContextInvalid, .presentationContextNotProvided:
                        finalError = .presentationError
                    default:
                        finalError = .webAuthenticationError(error)
                    }
                } else {
                    finalError = .unknownError
                }

                completion(.failure(finalError))
                return
            }

            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            if let token = queryItems?.first(where: { $0.name == self.config.authCallbackTokenQueryParamName })?.value {
                self.postNotification(with: token)
                completion(.success(.token(token)))
            } else {
                self.postNotification(with: nil)
                completion(.success(.otherCallback(callbackURL)))
            }
        }

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = config.ephemeralWebSession
        authSession?.start()
    }

    private func postNotification(with token: String?) {
        NotificationCenter.default.post(
            name: config.authStatusChangedNotificationName,
            object: nil,
            userInfo: [config.authStatusChangedNotificationInfo: token ?? ""])
    }

    // MARK: ASWebAuthenticationPresentationContextProviding

    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        presenterVC?.view.window ?? UIWindow()
    }
}
