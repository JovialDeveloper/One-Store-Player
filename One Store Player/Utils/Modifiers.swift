//
//  Modifiers.swift
//  One Store Player
//
//  Created by MacBook Pro on 05/11/2022.
//

import SwiftUI
import UIKit
struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGroupedBackground)))
    }
}
