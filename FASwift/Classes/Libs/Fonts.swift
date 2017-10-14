//
//  Fonts.swift
//  FASwift
//
//  Created by Ondrej Rafaj on 14/10/2017.
//

import Foundation


public enum Font: String {
    case brands = "fontawesome-pro-brands-900"
    case light = "fontawesome-pro-light-300"
    case regular = "fontawesome-pro-regular-400"
    case solid = "fontawesome-pro-solid-900"
    
    var file: String {
        return rawValue
    }
    
    var name: String {
        switch self {
        case .brands:
            return "Font Awesome 5 Pro Brands"
        case .light:
            return "Font Awesome 5 Pro Light"
        case .regular:
            return "Font Awesome 5 Pro Regular"
        case .solid:
            return "Font Awesome 5 Pro Solid"
        }
    }
}

class Fonts {
    
    private static func prepare(type: Font) {
        if (UIFont.fontNames(forFamilyName: type.name).count == 0) {
            let bundle = Bundle(for: Fonts.self)
            var fontURL: URL!
            let identifier = bundle.bundleIdentifier
            
            if identifier?.hasPrefix("org.cocoapods") == true {
                fontURL = bundle.url(forResource: type.file, withExtension: "ttf", subdirectory: "FASwift.bundle")
            }
            else {
                fontURL = bundle.url(forResource: type.file, withExtension: "ttf")
            }
            let data = try! Data(contentsOf: fontURL as URL)
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)
            
            var error: Unmanaged<CFError>?
            
            if CTFontManagerRegisterGraphicsFont(font!, &error) == false {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
        }
    }
    
    static func load(type: Font) {
        prepare(type: .brands)
        if type != .brands {
            prepare(type: type)
        }
    }
    
}