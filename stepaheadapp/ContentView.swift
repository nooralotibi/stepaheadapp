//
//  ContentView.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//


import SwiftUI
import Vision
import PhotosUI
import SwiftData
import AVFoundation


struct ContentView: View {
    @Environment(\.modelContext)  var context
   
//    @Query  var extract: [extractxt]

  
    @State private var selectedFont = "AvenirNext-Regular"
    @State private var fontSize: CGFloat = 16.0
    @State private var selectedColor = Color.black
    @State var isshowing = false
    @State private var isEdit = false
    let availableFonts = ["AvenirNext-Regular", "HelveticaNeue-UltraLight", "TimesNewRomanPSMT", "Times New Roman", "Courier New Bold Italic"]
    @State var uploadimages: UIImage?
    @State private var photositem: PhotosPickerItem?
    @State private var recognizedText: String = ""
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var photoUploaded = false
   @Query var extract: [extractxt]
 @State  var extracts: [extractxt] = []
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Add photo")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .padding(.trailing, 180)
                    
                        .padding(.trailing, 222)
                    
                    NavigationLink(destination: ExtractedList(extract: extract)) {
                        Image(systemName: "folder")
                        Text("Extracted Text")
                    }
                    .foregroundColor(.blue.opacity(0.8))
                }
                
                
                PhotosPicker(selection: $photositem, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.artframe")
                    Text("Select a photo from PhotoPicker")
                        .padding(.trailing, 400)
                }
                .foregroundColor(.blue.opacity(0.8))
                
                if uploadimages != nil {
                    Image(uiImage: uploadimages!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 280)
                }
                
                Button("Recognize Text") {
                    extractText(from: uploadimages!)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(50)
                
                ScrollView {
                    VStack {
                        if isEdit {
                            TextEditor(text: $recognizedText)
                                .font(.custom(selectedFont, size: fontSize))
                                .foregroundColor(selectedColor)
                        } else {
                            Text(recognizedText)
                                .font(.custom(selectedFont, size: fontSize))
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
                    }
                    .padding()
                }
                
            }
            
            HStack{
                HStack{
                    Button {
                        
                        Speak()
                    }label: {
                        Text("Speak")
                        Image(systemName: "voiceover")
                        
                        
                    } .font(.body)
                        .foregroundColor(.blue.opacity(0.8))
                    
                    Button{
                        stopSpeaking()
                    } label: {
                        Image(systemName: "stop.circle")
                    }  .foregroundColor(.blue.opacity(0.8))
                }
                Button{
                    isshowing = true
                }label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue.opacity(0.8))
                }.sheet(isPresented: $isshowing){
                    VStack{
                        Button{
                            isshowing = false
                        }label:{
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                        
                        HStack{
                            Text("Select Font")
                            Spacer()
                            Picker("Font", selection: $selectedFont) {
                                ForEach(availableFonts, id: \.self) { font in
                                    Text(font).font(.custom(font, size: 16))
                                }
                            }
                            
                        } .font(.body) .foregroundColor(.black.opacity(0.7))
                        ColorPicker("Select Color", selection: $selectedColor)
                            .font(.body) .foregroundColor(.black.opacity(0.7))
                        HStack{
                            Text("Select font size")
                            Slider(value: $fontSize, in: 12...30, step: 1)
                        }.font(.body) .foregroundColor(.black.opacity(0.7))
                        
                    }
                }                            .presentationDetents([.height(150), .medium])
                
                
                
                
                
                
                    .padding()
                    .onChange(of: photositem) { _,_ in
                        Task {
                            do {
                                if let data = try await photositem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        self.uploadimages = uiImage
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)
                                photositem = nil
                            }
                        }
                        
                    }
                
                
                    .padding()
            }
            
            Button("Save"){
                let extracts = extractxt(
                    recognizedText: recognizedText,
                    font: selectedFont,
                    //                    color: selectedColor,
                    size: fontSize
                )
                
                context.insert(extracts)
                //}
                do {
                    try context.save()
                    print("Text saved successfully!")
                    
                    
                } catch {
                    print("Error saving text:", error.localizedDescription)
                }
                
            } .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom,66)
        }
    }

    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let textRecognizationRequest = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            let extractedText = results.compactMap { result in
                return result.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            DispatchQueue.main.async {
                self.recognizedText = extractedText
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        do {
            try handler.perform([textRecognizationRequest])
        } catch {
            print(error)
        }
    }
    
    func Speak() {
        let utterance = AVSpeechUtterance(string: recognizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)

    }
    private func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        
    }
 
}



#Preview {
    NavigationStack{
        ContentView()
            .modelContainer(for: [extractxt.self])
    }
}
