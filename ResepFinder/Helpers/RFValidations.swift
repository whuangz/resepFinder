//
//  RFValidations.swift
//  ResepFinder
//
//  Created by William Huang on 08/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFValidations: NSObject {
    static func validatewith(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
