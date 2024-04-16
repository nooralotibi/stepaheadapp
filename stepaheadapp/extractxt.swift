//
//  extractxt.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//


import Foundation
import SwiftData

@Model
 class extractxt {
     
   var recognizedText : String
     var font: String = "Default"

    var size: Double = 16

     init( recognizedText: String,font: String,size: Double){

        self.recognizedText = recognizedText
        self.font = font
         self.size = size

         
    }
}
