// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum AvenirNextCyr {
    internal static let medium = FontConvertible(name: "AvenirNextCyr-Medium", family: "Avenir Next Cyr", path: "Avenir Next.ttf")
    internal static let all: [FontConvertible] = [medium]
  }
  internal enum HelveticaNeue {
    internal static let bold = FontConvertible(name: "HelveticaNeue-Bold", family: "Helvetica Neue", path: "HelveticaNeue-Bold.otf")
    internal static let light = FontConvertible(name: "HelveticaNeue-Light", family: "Helvetica Neue", path: "HelveticaNeue-Light.otf")
    internal static let medium = FontConvertible(name: "HelveticaNeue-Medium", family: "Helvetica Neue", path: "HelveticaNeue-Medium.otf")
    internal static let regular = FontConvertible(name: "HelveticaNeue-Roman", family: "Helvetica Neue", path: "HelveticaNeue-Roman.otf")
    internal static let thin = FontConvertible(name: "HelveticaNeue-Thin", family: "Helvetica Neue", path: "HelveticaNeue-Thin.otf")
    internal static let all: [FontConvertible] = [bold, light, medium, regular, thin]
  }
  internal enum Inter {
    internal static let regular = FontConvertible(name: "Inter-Regular", family: "Inter", path: "Inter.ttf")
    internal static let black = FontConvertible(name: "Inter-Regular_Black", family: "Inter", path: "Inter.ttf")
    internal static let bold = FontConvertible(name: "Inter-Regular_Bold", family: "Inter", path: "Inter.ttf")
    internal static let extraBold = FontConvertible(name: "Inter-Regular_ExtraBold", family: "Inter", path: "Inter.ttf")
    internal static let extraLight = FontConvertible(name: "Inter-Regular_ExtraLight", family: "Inter", path: "Inter.ttf")
    internal static let light = FontConvertible(name: "Inter-Regular_Light", family: "Inter", path: "Inter.ttf")
    internal static let medium = FontConvertible(name: "Inter-Regular_Medium", family: "Inter", path: "Inter.ttf")
    internal static let semiBold = FontConvertible(name: "Inter-Regular_SemiBold", family: "Inter", path: "Inter.ttf")
    internal static let thin = FontConvertible(name: "Inter-Regular_Thin", family: "Inter", path: "Inter.ttf")
    internal static let all: [FontConvertible] = [regular, black, bold, extraBold, extraLight, light, medium, semiBold, thin]
  }
  internal enum Montserrat {
    internal static let black = FontConvertible(name: "Montserrat-Black", family: "Montserrat", path: "Montserrat.ttf")
    internal static let bold = FontConvertible(name: "Montserrat-Bold", family: "Montserrat", path: "Montserrat.ttf")
    internal static let extraBold = FontConvertible(name: "Montserrat-ExtraBold", family: "Montserrat", path: "Montserrat.ttf")
    internal static let extraLight = FontConvertible(name: "Montserrat-ExtraLight", family: "Montserrat", path: "Montserrat.ttf")
    internal static let light = FontConvertible(name: "Montserrat-Light", family: "Montserrat", path: "Montserrat.ttf")
    internal static let medium = FontConvertible(name: "Montserrat-Medium", family: "Montserrat", path: "Montserrat.ttf")
    internal static let regular = FontConvertible(name: "Montserrat-Regular", family: "Montserrat", path: "Montserrat.ttf")
    internal static let semiBold = FontConvertible(name: "Montserrat-SemiBold", family: "Montserrat", path: "Montserrat.ttf")
    internal static let thin = FontConvertible(name: "Montserrat-Thin", family: "Montserrat", path: "Montserrat.ttf")
    internal static let all: [FontConvertible] = [black, bold, extraBold, extraLight, light, medium, regular, semiBold, thin]
  }
  internal static let allCustomFonts: [FontConvertible] = [AvenirNextCyr.all, HelveticaNeue.all, Inter.all, Montserrat.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
