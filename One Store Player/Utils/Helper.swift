//
//  Helper.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import Foundation
import UIKit
import SwiftUI
struct OnePlayerFonts{
    
    static let cairoBold = UIFont(name: "cairo_bold", size: 20)
    static let cairoLight = UIFont(name: "cairo_light", size: 16)
    static let cairo_regular = UIFont(name: "cairo_regular", size: 18)
}
extension Font{
    
    static let carioBold = Font.custom("cairo_bold", size: 18)
    static let carioSmallBold = Font.custom("cairo_bold", size: 13)
    
    ///Font(OnePlayerFonts.cairoBold!)
    static let carioLight = Font.custom("cairo_light", size: 12)
    //Font(OnePlayerFonts.cairoLight ?? .systemFont(ofSize: 16, weight: .light))
    
    static let carioRegular = Font.custom("cairo_regular", size: 14)
    
    struct TVFonts{
        static let carioBold = Font.custom("cairo_bold", size: 30)
        
        ///Font(OnePlayerFonts.cairoBold!)
        static let carioLight = Font.custom("cairo_light", size: 22)
        //Font(OnePlayerFonts.cairoLight ?? .systemFont(ofSize: 16, weight: .light))
        
        static let carioRegular = Font.custom("cairo_regular", size: 25)
    }
    
      //Font(OnePlayerFonts.cairo_regular ?? .systemFont(ofSize: 18, weight: .regular))
}
extension Color {
    static let primaryColor = Color("PrimaryBColor")
    static let secondaryColor = Color("SecondaryBColor")
    static let oneColor = Color("1")
    static let secondColor = Color("2")
    static let selectedColor = Color("SelectedColor")
    
}
extension LinearGradient {
    static let bgGradient = LinearGradient(colors: [Color.oneColor,Color.secondaryColor], startPoint:UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude))
}

extension Date {
    
    func getTime(format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {

    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
    func localized(_ language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }

    /// Localizes a string using given language from Language enum.
    ///  - Parameters:
    ///  - language: The language that will be used to localized string.
    ///  - args:  dynamic arguments provided for the localized string.
    /// - Returns: localized string.
    func localized(_ language: String, args arguments: CVarArg...) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return String(format: localized(bundle: bundle), arguments: arguments)
    }

    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func getDateFormatted(givenFormat:String = "yyyy-MM-dd HH:mm:ssZ",format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        
        
        guard let date = dateFormatter.date(from: self)
        else {
            return "---"
        }
        
        let dateFormatter1 =  DateFormatter()
        dateFormatter1.dateFormat = format
        return dateFormatter1.string(from: date)
    }
}


class LocalStorgage{
    static let store = LocalStorgage()
    
    func storeObject<T:Codable>(array:[T],key:String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array){
            UserDefaults.standard.set(encoded, forKey: key)
            debugPrint("Save in Local")
        }
    }
    
    func storeSingleObject<T:Codable>(array:T,key:String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(array){
            UserDefaults.standard.set(encoded, forKey: key)
            debugPrint("Save in Local")
        }
    }
    
    func deleteObject(key:String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
   func getObject<T:Codable>(key:String)-> [T] {
        let decoder = JSONDecoder()
        if let streamsData = UserDefaults.standard.value(forKey: key) as? Data
        {
            if let strs = try? decoder.decode([T].self, from: streamsData) {
                return strs
            }
             return []
        }else {
            return []
        }
        
    }
    func getSingleObject<T:Codable>(key:String)-> T?{
         let decoder = JSONDecoder()
         if let streamsData = UserDefaults.standard.value(forKey: key) as? Data
         {
             if let strs = try? decoder.decode(T.self, from: streamsData) {
                 return strs
             }
              return nil
         }else {
             return nil
         }
         
     }
}
