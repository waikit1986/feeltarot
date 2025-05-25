//
//  MenuView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//


import SwiftUI

struct MenuView: View {
    
    var body: some View {
            VStack {
                Spacer()
                
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
            }
            .foregroundStyle(Color("AccentColor"))
            .background(Color.black)
            .fontWeight(.semibold)
            .frame(height: UIScreen.main.bounds.height * 0.05)
        }
    }


#Preview {
    MenuView()
}
