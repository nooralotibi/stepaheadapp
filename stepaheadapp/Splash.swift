//
//  Splash.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//

import SwiftUI

struct Splash: View {
    
    @State private var isActive = false

    @State private var presentOnbording = false
    @State  var offset: Int
    
    var body: some View {
        
     
        NavigationStack{
                ZStack{
          
            LinearGradient(
                gradient: Gradient(colors: [.accentColor,.blue]
                                 
                                  ),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
                
                    ZStack{
                        
                        
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 280)
                        Text("StepAhead")
                            .font(.title)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top,176)
                    }
            }
                    
                
            }

                .fullScreenCover(isPresented: $presentOnbording) {
                    Onboarding()
                }
                
                
            
        
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        withAnimation {
                            self.isActive = true
                            presentOnbording.toggle()
                        }
                    }
                }
                
            
        
    }
    }

#Preview {
    Splash(offset: 1)
}
