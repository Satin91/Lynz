import SwiftUI

extension Font {
    // MARK: - SF Pro Font Extensions
    
    /// SF Pro Bold 70 with kerning -2% - Main header
    static let lynzBold70 = Font.system(size: 70)
        .weight(.bold)
//        .kerning(-0.02)
    
    /// SF Pro Semibold 24 - Section header
    static let lynzSemibold24 = Font.system(size: 24)
        .weight(.semibold)
    
    /// SF Pro Regular 14 with kerning -0.43 - Small text
    static let lynzRegular14 = Font.system(size: 14)
        .weight(.regular)
//        .kerning(-0.0043)
    
    /// SF Pro Medium 17 with kerning -0.43 - Main text
    static let lynzMedium17 = Font.system(size: 17)
        .weight(.medium)
//        .kerning(-0.0043)
    
    /// SF Pro Semibold 33 - Main header
    static let lynzSemibold33 = Font.system(size: 33)
        .weight(.semibold)
    
    /// SF Pro Medium 20 - Subtitle
    static let lynzMedium20 = Font.system(size: 20)
        .weight(.medium)
    
    /// SF Pro Light 18 - Additional text
    static let lynzLight18 = Font.system(size: 18)
        .weight(.light)
    
    /// SF Pro Semibold 15 - Accent text
    static let lynzSemibold15 = Font.system(size: 15)
        .weight(.semibold)
    
    /// SF Pro Bold 16 - Emphasized text
    static let lynzBold16 = Font.system(size: 16)
        .weight(.bold)
    
    // MARK: - Semantic Font Names (Designer-friendly)
    
    /// Main header - Bold 70, kerning -2%
    static let lzHeader = lynzBold70
    
    /// Main header - Semibold 33
    static let lzTitle = lynzSemibold33
    
    /// Section header - Semibold 24
    static let lzSectionHeader = lynzSemibold24
    
    /// Subtitle - Medium 20
    static let lzSubtitle = lynzMedium20
    
    /// Main text - Medium 17, kerning -0.43
    static let lzBody = lynzMedium17
    
    /// Additional text - Light 18
    static let lzCaption = lynzLight18
    
    /// Accent text - Semibold 15
    static let lzAccent = lynzSemibold15
    
    /// Emphasized text - Bold 16
    static let lzEmphasis = lynzBold16
    
    /// Small text - Regular 14, kerning -0.43
    static let lzSmall = lynzRegular14
}

// MARK: - Font Modifier Extensions

extension View {
    /// Applies SF Pro Bold 70 with kerning -2%
    func lynzBold70() -> some View {
        self.font(.lynzBold70)
    }
    
    /// Applies SF Pro Semibold 24
    func lynzSemibold24() -> some View {
        self.font(.lynzSemibold24)
    }
    
    /// Applies SF Pro Regular 14 with kerning -0.43
    func lynzRegular14() -> some View {
        self.font(.lynzRegular14)
    }
    
    /// Applies SF Pro Medium 17 with kerning -0.43
    func lynzMedium17() -> some View {
        self.font(.lynzMedium17)
    }
    
    /// Applies SF Pro Semibold 33
    func lynzSemibold33() -> some View {
        self.font(.lynzSemibold33)
    }
    
    /// Applies SF Pro Medium 20
    func lynzMedium20() -> some View {
        self.font(.lynzMedium20)
    }
    
    /// Applies SF Pro Light 18
    func lynzLight18() -> some View {
        self.font(.lynzLight18)
    }
    
    /// Applies SF Pro Semibold 15
    func lynzSemibold15() -> some View {
        self.font(.lynzSemibold15)
    }
    
    /// Applies SF Pro Bold 16
    func lynzBold16() -> some View {
        self.font(.lynzBold16)
    }
}

// MARK: - Font Constants for Easy Access

struct LynzFontConstants {
    /// Main headers
    struct Headlines {
        static let large = Font.lzHeader
        static let medium = Font.lzTitle
        static let small = Font.lzSectionHeader
    }
    
    /// Main text
    struct Body {
        static let large = Font.lzSubtitle
        static let medium = Font.lzBody
        static let small = Font.lzSmall
    }
    
    /// Additional text
    struct Caption {
        static let primary = Font.lzCaption
        static let secondary = Font.lzAccent
        static let tertiary = Font.lzEmphasis
    }
}

// MARK: - Font Extensions for Easy Access

extension Font {
    /// Access to Lynz fonts through convenient properties
    static let lynz = LynzFontConstants.self
    
    /// Headers
    static let lynzHeadlines = LynzFontConstants.Headlines.self
    
    /// Main text
    static let lynzBody = LynzFontConstants.Body.self
    
    /// Additional text
    static let lynzCaption = LynzFontConstants.Caption.self
}
