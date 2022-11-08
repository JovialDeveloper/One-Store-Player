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
    static let carioBold = Font(OnePlayerFonts.cairoBold ?? .systemFont(ofSize: 20, weight: .bold))
    static let carioLight = Font(OnePlayerFonts.cairoLight ?? .systemFont(ofSize: 16, weight: .light))
    
    static let carioRegular = Font(OnePlayerFonts.cairo_regular ?? .systemFont(ofSize: 18, weight: .regular))
}
