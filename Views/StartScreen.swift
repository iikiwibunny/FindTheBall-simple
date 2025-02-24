import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Find the Ball")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .foregroundStyle(.pink)
                
                Text("Time for an AR Scavenger Hunt!")
                    .font(.title2)
                    .foregroundStyle(.purple)
                
                NavigationLink(destination: ContentView()) {
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
}


#Preview {
    StartScreen()
}
