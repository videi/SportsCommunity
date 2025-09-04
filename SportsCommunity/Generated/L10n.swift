// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Alert {
    public enum Action {
      /// No
      public static let no = L10n.tr("Localizable", "Alert.Action.no", fallback: "No")
      /// Yes
      public static let yes = L10n.tr("Localizable", "Alert.Action.yes", fallback: "Yes")
    }
  }
  public enum Auth {
    /// Get code
    public static let getCode = L10n.tr("Localizable", "Auth.GetCode", fallback: "Get code")
    public enum CodeInput {
      /// Enter the code
      public static let header = L10n.tr("Localizable", "Auth.CodeInput.header", fallback: "Enter the code")
    }
    public enum PhoneNumber {
      /// Enter your phone number
      public static let header = L10n.tr("Localizable", "Auth.PhoneNumber.header", fallback: "Enter your phone number")
    }
    public enum Registration {
      /// Registration
      public static let title = L10n.tr("Localizable", "Auth.Registration.title", fallback: "Registration")
    }
  }
  public enum Button {
    /// Cancel
    public static let cancel = L10n.tr("Localizable", "Button.cancel", fallback: "Cancel")
    /// Create
    public static let create = L10n.tr("Localizable", "Button.create", fallback: "Create")
    /// Done
    public static let done = L10n.tr("Localizable", "Button.done", fallback: "Done")
  }
  public enum Main {
    public enum Events {
      /// Events
      public static let title = L10n.tr("Localizable", "Main.Events.title", fallback: "Events")
      public enum Cell {
        public enum Content {
          public enum SecondaryText {
            /// Place
            public static let address = L10n.tr("Localizable", "Main.Events.Cell.Content.SecondaryText.Address", fallback: "Place")
            /// Date
            public static let date = L10n.tr("Localizable", "Main.Events.Cell.Content.SecondaryText.Date", fallback: "Date")
            /// Participants
            public static let participants = L10n.tr("Localizable", "Main.Events.Cell.Content.SecondaryText.Participants", fallback: "Participants")
            /// Sport
            public static let sportType = L10n.tr("Localizable", "Main.Events.Cell.Content.SecondaryText.SportType", fallback: "Sport")
          }
        }
      }
      public enum Create {
        /// New event
        public static let title = L10n.tr("Localizable", "Main.Events.Create.title", fallback: "New event")
      }
      public enum TableView {
        /// There are no events on the selected date
        public static let notFound = L10n.tr("Localizable", "Main.Events.TableView.NotFound", fallback: "There are no events on the selected date")
      }
    }
    public enum Profile {
      /// Profile
      public static let title = L10n.tr("Localizable", "Main.Profile.title", fallback: "Profile")
      public enum Edit {
        public enum Button {
          /// Change photo
          public static let changePhoto = L10n.tr("Localizable", "Main.Profile.Edit.Button.changePhoto", fallback: "Change photo")
          /// Logout
          public static let logout = L10n.tr("Localizable", "Main.Profile.Edit.Button.logout", fallback: "Logout")
        }
        public enum TexField {
          /// Date of birth
          public static let birthday = L10n.tr("Localizable", "Main.Profile.Edit.TexField.birthday", fallback: "Date of birth")
          /// E-mail
          public static let email = L10n.tr("Localizable", "Main.Profile.Edit.TexField.email", fallback: "E-mail")
          /// Name
          public static let name = L10n.tr("Localizable", "Main.Profile.Edit.TexField.name", fallback: "Name")
          /// Surname
          public static let surname = L10n.tr("Localizable", "Main.Profile.Edit.TexField.surname", fallback: "Surname")
        }
      }
    }
    public enum Settings {
      /// Settings
      public static let title = L10n.tr("Localizable", "Main.Settings.title", fallback: "Settings")
    }
  }
  public enum Message {
    public enum CodeInput {
      /// You can request a code in
      public static let notify = L10n.tr("Localizable", "Message.CodeInput.notify", fallback: "You can request a code in")
      public enum Notify {
        /// seconds
        public static let sec = L10n.tr("Localizable", "Message.CodeInput.notify.sec", fallback: "seconds")
      }
    }
    public enum Error {
      /// Error
      public static let title = L10n.tr("Localizable", "Message.Error.title", fallback: "Error")
    }
    public enum Events {
      public enum Create {
        /// Failed to create event
        public static let failure = L10n.tr("Localizable", "Message.Events.Create.failure", fallback: "Failed to create event")
      }
      public enum Delete {
        /// Failed to delete event
        public static let failure = L10n.tr("Localizable", "Message.Events.Delete.failure", fallback: "Failed to delete event")
      }
      public enum Edit {
        /// Failed to update event data
        public static let failure = L10n.tr("Localizable", "Message.Events.Edit.failure", fallback: "Failed to update event data")
        /// Incorrectly entered event data
        public static let notvalid = L10n.tr("Localizable", "Message.Events.Edit.notvalid", fallback: "Incorrectly entered event data")
      }
      public enum Load {
        /// Failed to load events information
        public static let failure = L10n.tr("Localizable", "Message.Events.Load.failure", fallback: "Failed to load events information")
      }
    }
    public enum Notify {
      /// Localizable.strings
      ///   SportsCommuinty
      /// 
      ///   Created by Илья Макаров on 11.03.2025.
      public static let title = L10n.tr("Localizable", "Message.Notify.title", fallback: "Notify")
    }
    public enum PhoneNumber {
      /// Please enter your phone number
      public static let empty = L10n.tr("Localizable", "Message.PhoneNumber.empty", fallback: "Please enter your phone number")
      /// Failed to send phone number
      public static let failure = L10n.tr("Localizable", "Message.PhoneNumber.failure", fallback: "Failed to send phone number")
      /// Invalid phone number
      public static let wrong = L10n.tr("Localizable", "Message.PhoneNumber.wrong", fallback: "Invalid phone number")
    }
    public enum Profile {
      public enum Edit {
        /// Failed to save new profile data
        public static let failure = L10n.tr("Localizable", "Message.Profile.Edit.failure", fallback: "Failed to save new profile data")
      }
      public enum Exit {
        /// Are you sure you want to log out of your profile?
        public static let question = L10n.tr("Localizable", "Message.Profile.Exit.question", fallback: "Are you sure you want to log out of your profile?")
      }
      public enum Load {
        /// Failed to load profile information
        public static let failure = L10n.tr("Localizable", "Message.Profile.Load.failure", fallback: "Failed to load profile information")
      }
    }
    public enum Service {
      /// The service has thrown an exception
      public static let error = L10n.tr("Localizable", "Message.Service.error", fallback: "The service has thrown an exception")
    }
    public enum Valid {
      /// Check the data
      public static let title = L10n.tr("Localizable", "Message.Valid.title", fallback: "Check the data")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
