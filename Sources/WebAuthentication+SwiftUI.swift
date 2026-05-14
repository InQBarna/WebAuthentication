//
//  WebAuthentication+SwiftUI.swift
//  WebAuthentication
//

import SwiftUI
import UIKit

// MARK: - Convenience display without UIViewController

public extension WebAuthentication {

    /// Displays the web authentication flow resolving the presenter automatically.
    /// Use this overload from SwiftUI instead of passing a UIViewController manually.
    func display(_ url: URL, completion: @escaping (Result<WebAuthenticationResult, WebAuthenticationError>) -> Void) {
        guard let presenter = UIApplication.shared.topMostViewController() else {
            completion(.failure(.presentationError))
            return
        }
        display(url, from: presenter, completion: completion)
    }

    /// Async/await version of the authentication flow. Resolves the presenter automatically.
    ///
    /// ```swift
    /// let result = await auth.display(loginURL)
    /// if case .success(.token(let token)) = result { ... }
    /// ```
    func display(_ url: URL) async -> Result<WebAuthenticationResult, WebAuthenticationError> {
        await withCheckedContinuation { continuation in
            display(url) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

// MARK: - SwiftUI View Modifier

public extension View {

    /// Attaches web authentication to a view. Set `url` to trigger the flow; it resets to nil when done.
    ///
    /// ```swift
    /// .webAuthentication(auth, url: $authURL) { result in
    ///     switch result {
    ///     case .success(.token(let token)): ...
    ///     case .failure(let error): ...
    ///     }
    /// }
    /// ```
    func webAuthentication(
        _ webAuth: WebAuthentication,
        url: Binding<URL?>,
        onResult: @escaping (Result<WebAuthenticationResult, WebAuthenticationError>) -> Void
    ) -> some View {
        modifier(WebAuthenticationModifier(webAuth: webAuth, url: url, onResult: onResult))
    }
}

struct WebAuthenticationModifier: ViewModifier {
    let webAuth: WebAuthentication
    @Binding var url: URL?
    let onResult: (Result<WebAuthenticationResult, WebAuthenticationError>) -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: url) { newURL in
                guard let authURL = newURL else { return }
                webAuth.display(authURL) { result in
                    DispatchQueue.main.async {
                        url = nil
                        onResult(result)
                    }
                }
            }
    }
}

// MARK: - UIApplication helper

private extension UIApplication {
    func topMostViewController() -> UIViewController? {
        let keyWindow = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        return keyWindow?.rootViewController?.topMostViewController()
    }
}

private extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
