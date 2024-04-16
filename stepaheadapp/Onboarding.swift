//
//  Onboarding.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//



import SwiftUI

struct Onboarding:View{
    
    let sentences = ["There are at least 2.2 billion people worldwide who have vision impairment.","You can extract text from images, customize it, and listen to it.","It's easy to save and access the text anytime without the need for the internet."]
  
    var body: some View{
        NavigationStack{
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [.accentColor,.blue]
                                       
                                      ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack{
                    NavigationLink(
                        destination: ContentView(),
                        label: {
                            Image(systemName: "xmark")
                            Text("skip")
                            
                        })    .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .padding(.trailing,900)
                    TabView {
                        
                        ForEach(sentences, id: \.self) { sentence in
                            Text(sentence)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            
                        }
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    Onboarding()
}
