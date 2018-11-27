//
//  RFEnum.swift
//  ResepFinder
//
//  Created by William Huang on 12/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

enum RFCreateRecipeSection: Int{
    case upload
    case createRecipe
    case ingredients
    case steps
}

enum RFViewRecipeSection: Int {
    case header
    case description
    case comment
    case ingredients
}

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
