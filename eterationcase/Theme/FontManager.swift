//
//  ECFont.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 26.12.2024.
//

import UIKit

enum FontStyle {
    case regular
    case medium
    case semibold
    case bold

    var fontName: String {
        switch self {
        case .regular: return "Montserrat-Regular"
        case .medium: return "Montserrat-Medium"
        case .semibold: return "Montserrat-SemiBold"
        case .bold: return "Montserrat-Bold"
        }
    }
}

enum FontSize: CGFloat {
    case body1 = 16.0
    case body2 = 14.0
    case body3 = 12.0
    case body4 = 10.0
    case heading1 = 24.0
    case heading2 = 20.0
    case heading3 = 18.0
}

struct FontManager {
    static func customFont(size: FontSize, style: FontStyle) -> UIFont {
        if let font = UIFont(name: style.fontName, size: size.rawValue) {
            return font
        } else {
            // Fallback font if Montserrat is not found
            return UIFont.systemFont(ofSize: size.rawValue, weight: .regular)
        }
    }

    struct Body1 {
        static let regular = FontManager.customFont(size: .body1, style: .regular)
        static let medium = FontManager.customFont(size: .body1, style: .medium)
        static let semibold = FontManager.customFont(size: .body1, style: .semibold)
        static let bold = FontManager.customFont(size: .body1, style: .bold)
    }

    struct Body2 {
        static let regular = FontManager.customFont(size: .body2, style: .regular)
        static let medium = FontManager.customFont(size: .body2, style: .medium)
        static let semibold = FontManager.customFont(size: .body2, style: .semibold)
        static let bold = FontManager.customFont(size: .body2, style: .bold)
    }

    struct Body3 {
        static let regular = FontManager.customFont(size: .body3, style: .regular)
        static let medium = FontManager.customFont(size: .body3, style: .medium)
        static let semibold = FontManager.customFont(size: .body3, style: .semibold)
        static let bold = FontManager.customFont(size: .body3, style: .bold)
    }

    struct Body4 {
        static let regular = FontManager.customFont(size: .body4, style: .regular)
        static let medium = FontManager.customFont(size: .body4, style: .medium)
        static let semibold = FontManager.customFont(size: .body4, style: .semibold)
        static let bold = FontManager.customFont(size: .body4, style: .bold)
    }

    struct Heading1 {
        static let regular = FontManager.customFont(size: .heading1, style: .regular)
        static let medium = FontManager.customFont(size: .heading1, style: .medium)
        static let semibold = FontManager.customFont(size: .heading1, style: .semibold)
        static let bold = FontManager.customFont(size: .heading1, style: .bold)
    }

    struct Heading2 {
        static let regular = FontManager.customFont(size: .heading2, style: .regular)
        static let medium = FontManager.customFont(size: .heading2, style: .medium)
        static let semibold = FontManager.customFont(size: .heading2, style: .semibold)
        static let bold = FontManager.customFont(size: .heading2, style: .bold)
    }

    struct Heading3 {
        static let regular = FontManager.customFont(size: .heading3, style: .regular)
        static let medium = FontManager.customFont(size: .heading3, style: .medium)
        static let semibold = FontManager.customFont(size: .heading3, style: .semibold)
        static let bold = FontManager.customFont(size: .heading3, style: .bold)
    }
}

