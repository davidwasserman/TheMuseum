//
//  ContentView.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-05-28.
//

import SwiftUI
import RealityKit
import RealityKitContent

/// Description
/// Content displayed when first entering visionOS app.  General introduction and toggle for immersive view.
struct ContentView: View {

  @State private var showImmersiveSpace = false
  @State private var immersiveSpaceIsShown = false

  @Environment(\.openImmersiveSpace) var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

  var body: some View {
    VStack(spacing: 50) {

      // MARK: - Text for title and welcome message
      Text("Welcome to the Museum")
        .font(.extraLargeTitle)
        .bold()

      Text("Welcome to the Museum of Historical Artifacts.  This is a special museum that is currently honoring great women of history.  In this virtual museum, feel free to pick up the artifacts and examine up close.  When you're done, you can simply release them and they'll magically bounce back to their original positions.")
        .font(.title)
        .padding(.horizontal, 80)

      // MARK: - Toggle to enter the museum in an immersive space and dismiss this view
      Toggle("Enter the museum", isOn: $showImmersiveSpace)
        .font(.title)
        .frame(width: 360)
        .padding(24)
        .glassBackgroundEffect()
    }
    .padding()
    .glassBackgroundEffect()
    .onChange(of: showImmersiveSpace) { _, newValue in
      Task {
        if newValue {
          switch await openImmersiveSpace(id: "ImmersiveSpace") {
          case .opened:
            immersiveSpaceIsShown = true
          case .error, .userCancelled:
            fallthrough
          @unknown default:
            immersiveSpaceIsShown = false
            showImmersiveSpace = false
          }
        } else if immersiveSpaceIsShown {
          await dismissImmersiveSpace()
          immersiveSpaceIsShown = false
        }
      }
    }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
}
