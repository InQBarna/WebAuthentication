//
//  WebAuthenticationInterface.swift
//
//  Created by Alexis on 06/05/2020.
//  Copyright © 2020 InQBarna. All rights reserved.
//

import UIKit

/**
    Protocol for abstracting the login presentation method implementation details.
 */
public protocol WebAuthenticationInterface {
    func display(_ url: URL, from presenter: UIViewController, completion: @escaping ((String?) -> Void))
}
