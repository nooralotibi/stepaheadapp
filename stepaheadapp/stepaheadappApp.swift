//
//  stepaheadappApp.swift
//  stepaheadapp
//
//  Created by noor alotibi on 16/08/1445 AH.
//

import SwiftUI
import SwiftData
@main
struct stepaheadappApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [extractxt.self])
        }
    }
}
