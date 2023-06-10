//
//  DataManager.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import Firebase
import FirebaseAuth

final class DataManager {
    func signIn(email: String, password: String, completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as? NSError {
                completion(false, "Error \(error.code)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.operationNotAllowed.rawValue:
                    completion(false, "Не получилось!")
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(false, "Данный email уже используется!")
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(false, "Введен некорректный email!")
                case AuthErrorCode.weakPassword.rawValue:
                    completion(false, "Введен слишком простой пароль!")
                default:
                    completion(false, "Не получилось зарегистрироваться!")
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                completion(true, nil)
            }
        }
    }
    
    func logOut(completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch {
            completion(false, "Вы уже вышли из аккаунта")
        }
    }
}
