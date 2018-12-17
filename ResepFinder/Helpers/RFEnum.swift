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

enum RegionLoc: String {
    case KA
    case JW
    case SL
    case SM
    
    var rawValue: String {
        switch self {
        case .KA:
            return "Kalimantan"
        case .JW:
            return "Jawa"
        case .SL:
            return "Sulawesi"
        case .SM:
            return "Sumatera"
        }
    }
}
