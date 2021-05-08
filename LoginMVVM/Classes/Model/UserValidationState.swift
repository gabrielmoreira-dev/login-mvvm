//
//  UserValidationState.swift
//  LoginMVVM
//
//  Created by Gabriel Alves Moreira on 08/05/21.
//  Copyright © 2021 Gabriel Alves Moreira. All rights reserved.
//

import Foundation

enum UserValidationState {
    case valid
    case empty
    case invalidEmailFormat
    case shortPassword
}
