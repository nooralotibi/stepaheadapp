//
//  ExtractedList.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//

import SwiftUI
import SwiftData
struct ExtractedList: View {
    @Environment(\.modelContext) private var context

    let extract: [extractxt]
    
    private func deletextract(indexSet: IndexSet){
        indexSet.forEach { index in
            let extract = extract[index]
            context.delete(extract)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    var body: some View {
        VStack {
            Text("Extracted Text")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
                .padding(.trailing, 600)
            
            List {
                ForEach(extract) { extract in
                    NavigationLink(destination: extractetails(extract: extract)) {
                        Text(extract.recognizedText)
                            .font(.custom(extract.font, size: extract.size))
                    }
                }
                .onDelete(perform: deletextract)
            }
        }

    }
}

struct DetailsView: View {
    let extract: extractxt
    
    var body: some View {
        Text("Extracted text:")
        Text(extract.recognizedText)
            .font(.custom(extract.font, size: extract.size))
    }
}

//#Preview {
//    ExtractedList()
//}
