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
    case JA
    case SL
    case SM
    case BL
    
    var rawValue: String {
        switch self {
        case .KA:
            return "Kalimantan"
        case .JA:
            return "Jawa"
        case .SL:
            return "Sulawesi"
        case .SM:
            return "Sumatera"
        case .BL:
            return "Bali"
        }
    }
}

enum RegionLocByName: String {
    case Kalimantan
    case Jawa
    case Sulawesi
    case Sumatera
    case Bali
    
    var rawValue: String {
        switch self {
        case .Kalimantan:
            return "KA"
        case .Jawa:
            return "JA"
        case .Sulawesi:
            return "SL"
        case .Sumatera:
            return "SM"
        case .Bali:
            return "BL"
        }
    }
}
