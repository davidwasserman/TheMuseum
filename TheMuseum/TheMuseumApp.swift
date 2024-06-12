//
//  TheMuseumApp.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-05-28.
//

import SwiftUI

@main
struct TheMuseumApp: App {
    var body: some Scene {
        WindowGroup(id: "Content") {
            ContentView()
        }.windowStyle(.plain)

      WindowGroup(id: "DescriptionView", for: String.self) { value in
        DescriptionView(title: value.wrappedValue!)
      }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
