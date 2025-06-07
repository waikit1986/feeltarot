//
//  MenuView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/7/25.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    
    var body: some View {
        HStack {
            Image(systemName: "list.bullet.circle")
                .font(.title)
                .onTapGesture {
                    homeVM.selection = 1
                }
            
            Spacer()
            
            Image(systemName: "gearshape")
                .font(.title)
                .fontWeight(.semibold)
                .onTapGesture {
                    homeVM.selection = 2
                }
            
        }
        .foregroundStyle(Color("AccentColor"))
        .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
        .padding()
    }
}

#Preview {
    MenuView()
}
