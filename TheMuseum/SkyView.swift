//
//  SkyView.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-05-31.
//

import SwiftUI
import RealityKit

struct SkyView: View {
    var body: some View {

      SkyView()
      
      RealityView { content in
        guard let resource = try? await TextureResource(named: "skyView") else {
          return
        }
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))

        let entity = Entity()
        entity.components.set(ModelComponent(mesh: .generateSphere(radius: 1000), materials: [material]
        ))
        // point the texture inwards
        entity.scale *= .init(x: -1, y: 1, z: 1)

        content.add(entity)
      }
    }
}

#Preview {
    SkyView()
}
