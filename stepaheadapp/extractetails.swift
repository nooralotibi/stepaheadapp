//
//  extractetails.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//
import SwiftUI
import SwiftData

struct extractetails: View {
    @State private var selectedFont = "AvenirNext-Regular"
    @State private var fontSize: CGFloat = 16.0
    @State private var selectedColor = Color.black
    @State var isshowing = false
    @State private var isEdit = false
    let availableFonts = ["AvenirNext-Regular", "HelveticaNeue-UltraLight", "TimesNewRomanPSMT", "Times New Roman", "Courier New Bold Italic"]
    
    @Environment(\.modelContext) private var context
    let extract: extractxt
    @State private var recognizedText: String = ""
    
    var body: some View {
        VStack {
            Text("Update Text")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
                .padding(.trailing, 70)
            
            if isEdit {
                TextEditor(text: $recognizedText)
                        .font(.custom(extract.font, size: extract.size))
                    .foregroundColor(selectedColor)
                
            } else {
                Text(recognizedText)
                    .font(.custom(extract.font, size: extract.size))
                    .foregroundColor(selectedColor)
                    .background(.gray.opacity(0.2))
                    .shadow(radius: 10)
            }
            
            Button {
                isEdit.toggle()
            } label: {
                Text(isEdit ? "Done" : "Edit")
            }
            .foregroundColor(.blue.opacity(0.8))
            .onAppear {
                recognizedText = extract.recognizedText
                
            }
           
            Button("Update") {
                extract.recognizedText = recognizedText
                
                context.insert(extract)
                
                // Save the changes
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(10)
        }
    }
}

#Preview {
    extractetails(extract: extractxt(recognizedText: "",font: "default",size:16.0))
           .modelContainer(for: [extractxt.self])

}
