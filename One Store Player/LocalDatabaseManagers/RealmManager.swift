//
//  RealmManager.swift
//  One Store Player
//
//  Created by MacBook Pro on 18/05/2023.
//

import Foundation
import RealmSwift
import Realm
class RealmManager{
    
    static let shared = RealmManager()
    //let realm : Realm?
    func writeObject<T:Object>(object:T){
        do {
           let realm =  try Realm()
            try realm.write {
                realm.add(object)
                debugPrint("Save Data In Realm")
            }
        }catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getCategoryObject(object:CategoriesRealmModel)-> CategoriesRealmModel?{
        do {
           let realm =  try Realm()
            let object = realm.object(ofType: CategoriesRealmModel.self, forPrimaryKey: object.categoryName)
            return object
        }catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
