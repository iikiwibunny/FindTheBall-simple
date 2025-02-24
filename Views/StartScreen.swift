//
//  SwiftUIView.swift
//  FindTheBall
//
//  Created by Kennedy Pryor on 2/23/25.
//

import SwiftUI


struct StartScreen: View {
    var body: some View {
        VStack {
            
            Text("Find the Ball")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)
                .foregroundStyle(.pink)
            
            
            
            Text("Time for an AR Scavenger Hunt!")
                .font(.title2)
                .foregroundStyle(.purple)
            
            
            
            
            Button {
                print("Let's Go!")
            } label: {
                Text("Let's Go!")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
            }
                    
        }
        
        .padding()
                
    }
}

#Preview {
    StartScreen()
}
