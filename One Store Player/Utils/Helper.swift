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
    
    static let carioBold = Font.custom("cairo_bold", size: 20)
    
    ///Font(OnePlayerFonts.cairoBold!)
    static let carioLight = Font.custom("cairo_light", size: 16)
    //Font(OnePlayerFonts.cairoLight ?? .systemFont(ofSize: 16, weight: .light))
    
    static let carioRegular = Font.custom("cairo_regular", size: 17)
    
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
}
extension LinearGradient {
    static let bgGradient = LinearGradient(colors: [Color.oneColor,Color.secondaryColor], startPoint:UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude))
}
