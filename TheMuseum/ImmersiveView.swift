//
//  ImmersiveView.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-05-28.
//

import SwiftUI
import RealityKit
import RealityKitContent

/// Description
/// Immersive view displayed containing all museum content.
struct ImmersiveView: View {

  @Environment(\.dismissWindow) var dismissWindow
  @Environment(\.openWindow) var openWindow

  @State var lastGestureValueX = CGFloat(0)
  @State var lastGestureValueY = CGFloat(0)

  @State var originalPositionMariaTheresia = SIMD3(x: Float(0), y: Float(0), z: Float(0))
  @State var originalOrientationMariaTheresia = simd_quatf(angle: 0, axis: SIMD3(x: Float(0), y: Float(0), z: Float(0)))
  @State var originalPositionStAnna = SIMD3(x: Float(0), y: Float(0), z: Float(0))
  @State var originalOrientationStAnna = simd_quatf(angle: 0, axis: SIMD3(x: Float(0), y: Float(0), z: Float(0)))
  @State var originalPositionQueenJudith = SIMD3(x: Float(0), y: Float(0), z: Float(0))
  @State var originalOrientationQueenJudith = simd_quatf(angle: 0, axis: SIMD3(x: Float(0), y: Float(0), z: Float(0)))

  var body: some View {

    RealityView { content, attachments in
      // Add the initial RealityKit content
      if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {

        content.add(immersiveContentEntity)

        // MARK: - Occluded floor
        let floor = ModelEntity(mesh: .generatePlane(width: 100, depth: 100), materials: [OcclusionMaterial()])
        floor.generateCollisionShapes(recursive: false)
        floor.components[PhysicsBodyComponent.self] = .init(
          massProperties: .default,
          mode: .static
        )
        content.add(floor)

        // MARK: - ImageBasedLight for the immersive content
        guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
        let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
        immersiveContentEntity.components.set(iblComponent)
        immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))

        // MARK: - Maria Theresia entities
        if let mariaTheresiaEntity = immersiveContentEntity.findEntity(named: "MariaTheresia") {
          originalPositionMariaTheresia = mariaTheresiaEntity.position
          originalOrientationMariaTheresia = mariaTheresiaEntity.orientation
        }

        if let mariaTheresiaCubeEntity = immersiveContentEntity.findEntity(named: "MariaTheresiaCube") {
          if let mariaTheresiaEntityCubeAttachment = attachments.entity(for: "MariaTheresiaCubeAttachment") {
            mariaTheresiaEntityCubeAttachment.position = mariaTheresiaCubeEntity.position + [0, 0, 0.6]
            mariaTheresiaCubeEntity.addChild(mariaTheresiaEntityCubeAttachment, preservingWorldTransform: true)
          }
        }

        // MARK: - St. Anna entities
        if let stAnnaEntity = immersiveContentEntity.findEntity(named: "StAnna") {
          originalPositionStAnna = stAnnaEntity.position
          originalOrientationStAnna = originalOrientationStAnna
        }

        if let stAnnaCubeEntity = immersiveContentEntity.findEntity(named: "StAnnaCube") {
          if let stAnnaEntityCubeAttachment = attachments.entity(for: "StAnnaCubeAttachment") {
            stAnnaEntityCubeAttachment.position = stAnnaCubeEntity.position + [0, 0, 0.6]
            stAnnaCubeEntity.addChild(stAnnaEntityCubeAttachment, preservingWorldTransform: true)
          }
        }

        // MARK: - Queen Judith entities
        if let queenJudithEntity = immersiveContentEntity.findEntity(named: "QueenJudith") {
          originalPositionQueenJudith = queenJudithEntity.position
          originalOrientationQueenJudith = queenJudithEntity.orientation
        }

        if let queenJudithCubeEntity = immersiveContentEntity.findEntity(named: "QueenJudithCube") {
          if let queenJudithEntityCubeAttachment = attachments.entity(for: "QueenJudithCubeAttachment") {
            queenJudithEntityCubeAttachment.position = queenJudithCubeEntity.position + [0, 0, 0.6]
            queenJudithCubeEntity.addChild(queenJudithEntityCubeAttachment, preservingWorldTransform: true)
          }
        }
      }

    } placeholder: {
      ProgressView()
    } attachments: {  // Attachemnts added for labels on artifacts.
      Attachment(id: "MariaTheresiaCubeAttachment") {
        VStack(spacing: 100) {
          TitleTextView(title: "Maria Theresia")
          Button(action: {
            self.openWindow(id: "DescriptionView", value: "MariaTheresia")
          }, label: {
            LearnMoreButtonView()
          })
        }
      }
      Attachment(id: "StAnnaCubeAttachment") {
        VStack(spacing: 100) {
          TitleTextView(title: "St. Anna")
          Button(action: {
            self.openWindow(id: "DescriptionView", value: "StAnna")
          }, label: {
            LearnMoreButtonView()
          })
        }
      }
      Attachment(id: "QueenJudithCubeAttachment") {
        VStack(spacing: 100) {
          TitleTextView(title: "Queen Judith")
          Button(action: {
            self.openWindow(id: "DescriptionView", value: "QueenJudith")
          }, label: {
            LearnMoreButtonView()
          })
        }
      }
    }
    .gesture(dragGesture)
    .onAppear {
      dismissWindow(id: "Content")
    }
  }

  // MARK: - Drag Gesture
  var dragGesture: some Gesture {

    DragGesture(minimumDistance: 0.0)

      .targetedToAnyEntity()
      .onEnded { value in
        var transform = value.entity.transform
        if value.entity.name == "MariaTheresia" {
          transform.translation = originalPositionMariaTheresia
          transform.rotation = originalOrientationMariaTheresia
        }
        else if value.entity.name == "StAnna" {
          transform.translation = originalPositionStAnna
          transform.rotation = originalOrientationStAnna
        }
        else if value.entity.name == "QueenJudith" {
          transform.translation = originalPositionQueenJudith
          transform.rotation = originalOrientationQueenJudith
        }
        value.entity.move(to: transform, relativeTo: nil, duration: 0.5, timingFunction: .easeInOut)
      }

      .onChanged { value in
        let entity = value.entity
        let orientation = Rotation3D(entity.orientation(relativeTo: nil))
        var newOrientation: Rotation3D

        if (value.location.x >= lastGestureValueX) {
          newOrientation = orientation.rotated(by: .init(angle: .degrees(3.5), axis: .y))
        } else {
          newOrientation = orientation.rotated(by: .init(angle: .degrees(-3.5), axis: .y))
        }
        entity.setOrientation(.init(newOrientation), relativeTo: nil)
        lastGestureValueX = value.location.x

        value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
        value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic

      }
  }
}
#Preview(immersionStyle: .full) {
  ImmersiveView()
}
