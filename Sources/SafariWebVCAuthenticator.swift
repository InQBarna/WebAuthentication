//
//  SafariWebVCAuthenticator.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import Foundation
import SafariServices

/**
 SafariWebVCAuthenticator uses SFSafariViewController to manually load the Auth URLs and listen to the callback with the registered scheme received in the AppDelegate and propagated through the NotificationCenter.
 Used for iOS versions older than iOS 12.
 Once the deployment target is raised to iOS 12 we could just delete this implementation.
 */
class SafariWebVCAuthenticator: WebAuthenticationInterface {
    private var completionClosure: ((String?, WebAuthenticationError?) -> Void)?
    private var config: AuthConfiguration
    
    weak var safariVC: SFSafariViewController?
    
    init(config: AuthConfiguration) {
        self.config = config
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authStatusChanged(_:)),
            name: config.authStatusChangedNotificationName,
            object: nil
        )
    }

    func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((String?, WebAuthenticationError?) -> Void)) {
        completionClosure = completion

        let vc = SFSafariViewController(url: url)
        if #available(iOS 11.0, *) {
            vc.dismissButtonStyle = .close
        }
        if #available(iOS 10.0, *) {
            vc.preferredControlTintColor = .black
        }

        presenter.present(vc, animated: true, completion: nil)
        
        safariVC = vc
    }

    @objc private func authStatusChanged(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            if let token = data[config.authStatusChangedNotificationInfo],
               let completion = completionClosure {
                completion(token, nil)
            }
        }
    }
}
