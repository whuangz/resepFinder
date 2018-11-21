//
//  RFEnum.swift
//  ResepFinder
//
//  Created by William Huang on 12/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

enum RFProfileSection: Int {
    case description
    case details
    case recipes
}

enum RFSettingCell: Int {
    case logout
}

enum RFTabBarItem: Int {
    case home
    case createRecipe
    case conversation
    case profile
}
