//
//  WebAuthenticationInterface.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import UIKit

public enum WebAuthenticationError: Error {
    case userCancelled
    case presentationError
    case webAuthenticationError(Error)
    case unknownError
}

public enum WebAuthenticationResult {
    case token(String)
    case otherCallback(URL)
}

/**
    Protocol for abstracting the login presentation method implementation details.
 */
public protocol WebAuthenticationInterface {
    func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((Result<WebAuthenticationResult, WebAuthenticationError>) -> Void))
}
