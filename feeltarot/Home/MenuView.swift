//
//  MenuView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//


import SwiftUI

struct MenuView: View {
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "house")
                    .font(.title3)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "list.star")
                    .font(.title3)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05)
        .foregroundStyle(Color("AccentColor"))
        .background(Color.black)
        .fontWeight(.semibold)
    }
}


#Preview {
    MenuView()
}
