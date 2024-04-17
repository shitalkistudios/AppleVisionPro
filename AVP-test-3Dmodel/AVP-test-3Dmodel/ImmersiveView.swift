//
//  ImmersiveView.swift
//  AVP-test-3Dmodel
//
//  Created by Derrick Hsu on 4/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            let skybox = createSkybox()
              content.add(skybox!)
            
              guard let entity = try? await Entity(named: "AudioController", in: realityKitContentBundle) else { fatalError("Unable to load Immersive Model") }
              
              let ambientAudioController = entity.findEntity(named: "AmbientAudio")
              
              let audioFilename = "/Root/SailorMoon"
              
              guard let resource = try? await AudioFileResource(named: audioFilename, from: "AudioController.usda", in: realityKitContentBundle) else {
                  fatalError("Unable to load audio resource")}
              
              let audioController = ambientAudioController?.prepareAudio(resource)
              audioController?.play()
              
              content.add(entity)
              }
          }
      
      
      private func createSkybox() -> Entity? {
          let largeSphere = MeshResource.generateSphere(radius: 4)
          var skyboxMaterial = UnlitMaterial()
          
          do {
              let texture = try TextureResource.load(named: "Milkyway")
              skyboxMaterial.color = .init(texture: .init(texture))
          } catch {
              print("Failed to create skybox material: \(error)")
              return nil
          }
          
          let skyboxEntity = Entity()
          skyboxEntity.components.set(ModelComponent(mesh: largeSphere, materials: [skyboxMaterial]))
          
          skyboxEntity.scale = .init(x: -1, y:1, z:1)
          return skyboxEntity
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
