//
//  UIFont+Ext.swift
//  DMCommoniOS
//
//  Created by Bayu Kurniawan on 28/07/23.
//

import UIKit

public extension UIFont {
    
    static let loadCustomFonts: () = {
        loadFont("Poppins-Regular")
        loadFont("Poppins-SemiBold")
    }()
    
    enum FontWeight {
        case regular
        case semibold
    }
    
    static func poppins(_ weight: FontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "Poppins-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        case .semibold:
            return UIFont(name: "Poppins-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        }
    }
}

private extension UIFont {
    
    private class Typography {}
    
    static func loadFont(_ fontName: String) {
        let bundle = Bundle(for: Typography.self)
        let path = bundle.path(forResource: fontName, ofType: "ttf")
        let fontData = NSData(contentsOfFile: path!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        
        var errorRef: Unmanaged<CFError>? = nil
        
        if CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
