//
//  DataManager.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import Firebase
import FirebaseAuth

final class DataManager {
    func createUser(email: String, password: String) {
        print("START 2")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let error = error as? NSError {
              switch error.code {
            case AuthErrorCode.operationNotAllowed.rawValue:
                print("operationNotAllowed")
              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                  print("emailAlreadyInUse")
              // Error: The email address is already in use by another account.
            case AuthErrorCode.invalidEmail.rawValue:
                  print("invalidEmail")
              // Error: The email address is badly formatted.
            case AuthErrorCode.weakPassword.rawValue:
                  print("weakPassword \(password)")
              // Error: The password must be 6 characters long or more.
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            print("User signs up successfully")
            let newUserInfo = Auth.auth().currentUser
            let email = newUserInfo?.email
              print("User signs up successfully \(email)")
          }
        }
    }
}
