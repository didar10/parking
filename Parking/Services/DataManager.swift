//
//  DataManager.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 07.06.2023.
//

import Firebase
import FirebaseAuth

final class DataManager {
    private let database = Firestore.firestore()
    private var usersReference: CollectionReference {
        return database.collection("users")
    }
    
    private var carsReference: CollectionReference {
        return database.collection("cars")
    }
    
    private var parkingAreasReference: CollectionReference {
        return database.collection("parkingArea")
    }
    
    private var parkingSpacesReference: CollectionReference {
        return database.collection("parkingSpaces")
    }
    
    private var parkingHistoryReference: CollectionReference {
        return database.collection("history")
    }
    
    func signIn(email: String, password: String, completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as? NSError {
                completion(false, "Error \(error.code)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    func createUser(
        email: String, password: String,
        completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
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
                completion(true, nil)
            }
        }
    }
    
    func saveUserData(
        fio: String, phone: String,
        email: String, completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        let data = ["name": fio, "phone": phone, "email": email]
        let userId = Auth.auth().currentUser?.uid
        usersReference.document(userId!).setData(data) { error in
            if let error {
                completion(false, "Не получилось зарегистрироваться!")
                print("Error saving channel: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    func saveCarDetail(
        data: CarDetail,
        completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        let data = ["number": data.number, "color": data.color, "brand": data.brand, "model": data.model, "year": data.year]
        let userId = Auth.auth().currentUser?.uid
        carsReference.document(userId!).setData(data) { error in
            if let error {
                completion(false, "Не получилось зарегистрироваться!")
                print("Error saving channel: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    func getParkingArea(completion: @escaping(ParkingModel?) -> ()) {
        parkingAreasReference.getDocuments { snapshot, error in
            if let snapshot {
                if let first = snapshot.documents.first {
                    if let address = first.get("address") as? String,
                       let lat = first.get("lat") as? String,
                       let lon = first.get("lon") as? String {
                        let parkingModel = ParkingModel(address: address, lat: lat, lon: lon)
                        completion(parkingModel)
                    } else {
                        print("error getting field")
                        completion(nil)
                    }
                } else {
                    if let error {
                        print(error)
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func getParkingSpaces(completion: @escaping([ParkingSpace]?) -> ()) {
        parkingSpacesReference.getDocuments { snapshot, error in
            if let snapshot {
                var res = [ParkingSpace]()
                for i in snapshot.documents {
                    if let fromDate = i.get("fromDate") as? String,
                       let isAvailable = i.get("isAvailable") as? Bool,
                       let number = i.get("number") as? String,
                       let toDate = i.get("toDate") as? String {
                        let spaceModel = ParkingSpace(fromDate: fromDate, isAvailable: isAvailable, number: number, toDate: toDate)
                        res.append(spaceModel)
                    }
                }
                completion(res)
            }
        }
    }
    
    func changeParkingSpace(number: String, fromTime: String, toTime: String, completion: @escaping(Bool) -> ()) {
        let group = DispatchGroup()
        parkingSpacesReference.whereField(
            "number", isEqualTo: number).getDocuments { [weak self] snapshot, error in
            guard let self else { return }
            if let snapshot {
                for doc in snapshot.documents {
                    group.enter()
                    self.parkingSpacesReference.document(
                        doc.documentID).setData(
                            ["isAvailable": false,
                             "fromDate": fromTime,
                             "toDate": toTime],
                            merge: true)
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    completion(true)
                }
            }
            
            if let error {
                print(error)
                completion(false)
            }
        }
    }
    
    func saveParkingHistory(
        data: ParkingHistory,
        completion: @escaping(_ isSuccess: Bool, _ error: String?) -> ()) {
        if let userId = Auth.auth().currentUser?.uid {
            let data = ["parkingTime": "Время: \(data.parkingTime)",
                        "parkingName": data.parkingName,
                        "parkingSpaceNumber": "Место: \(data.parkingSpaceNumber)",
                        "userId": userId]
            parkingHistoryReference.addDocument(data: data) { error in
                if let error {
                    completion(false, "Не получилось!")
                    print("Error saving: \(error.localizedDescription)")
                } else {
                    completion(true, nil)
                }
            }
        } else {
            completion(false, "Не получилось!")
        }
    }
    
    func getParkingHistory(completion: @escaping([ParkingHistory]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let group = DispatchGroup()
        var parkings: [ParkingHistory]? = []
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.parkingHistoryReference.whereField("userId", isEqualTo: uid).getDocuments { snapShot, error in
                if let snapShot {
                    for document in snapShot.documents {
                        if let parkingName = document.get("parkingName") as? String,
                           let parkingSpaceNumber = document.get("parkingSpaceNumber") as? String,
                           let parkingTime = document.get("parkingTime") as? String {
                            group.enter()
                            let item = ParkingHistory(parkingName: parkingName, parkingSpaceNumber: parkingSpaceNumber, parkingTime: parkingTime)
                            parkings?.append(item)
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        completion(parkings)
                    }
                } else {
                    DispatchQueue.main.async {
                        if let error {
                            print(error)
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func getCarDetail(completion: @escaping(CarDetail?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        carsReference.document(uid).getDocument { snapshot, error in
            if let snapshot {
                if let number = snapshot.get("number") as? String,
                   let color = snapshot.get("color") as? String,
                   let brand = snapshot.get("brand") as? String,
                   let model = snapshot.get("model") as? String,
                   let year = snapshot.get("year") as? String {
                    let carDetail = CarDetail(
                        number: number,
                        color: color,
                        brand: brand,
                        model: model,
                        year: year)
                    completion(carDetail)
                } else {
                    print("error getting field")
                    completion(nil)
                }
            } else {
                if let error {
                    print(error)
                }
                completion(nil)
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
    
    func getProfile(completion: @escaping(Profile?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        usersReference.document(uid).getDocument { snapshot, error in
            if let snapshot {
                if let name = snapshot.get("name") as? String,
                   let email = snapshot.get("email") as? String,
                   let phone = snapshot.get("phone") as? String {
                    let profile = Profile(email: email, name: name, phone: phone)
                    completion(profile)
                } else {
                    print("error getting field")
                    completion(nil)
                }
            } else {
                if let error {
                    print(error)
                }
                completion(nil)
            }
        }
    }
}
