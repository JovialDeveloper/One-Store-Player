//
//  TVOS Settings.swift
//  One Store Player
//
//  Created by MacBook Pro on 25/11/2022.
//

import SwiftUI

struct TVOS_Settings: View {
    fileprivate let data = SettingsKeys.allCases
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            List(data,id: \.self){ item in
                Text(item.rawValue)
                    .foregroundColor(.black)
            }
        }
    }
}

struct TVOS_Settings_Previews: PreviewProvider {
    static var previews: some View {
        TVOS_Settings()
    }
}
