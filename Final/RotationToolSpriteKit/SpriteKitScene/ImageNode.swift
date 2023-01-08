import SpriteKit

final class ImageNode: SKNode {
    
    private let imageNode: SKSpriteNode
    private let imageContainerNode = SKNode()

    init(texture: SKTexture) {
        self.imageNode = SKSpriteNode(texture: texture)
        super.init()

        self.addChild(self.imageContainerNode)
        self.imageContainerNode.addChild(self.imageNode)

        // Affect quality of warp.
        self.imageNode.subdivisionLevels = 6
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError() }


    func setTexture(_ texture: SKTexture) {
        self.imageNode.texture = texture
        self.adjustSize(self.scene!.size)
    }
    
    func adjustSize(_ sceneSize: CGSize) {
        self.imageNode.size = SceneGeometry.scaleAspectFit(size: self.imageNode.texture!.size(), to: sceneSize)
    }
    
    func reset(completion: @escaping (() -> Void)) {
        let duration: CGFloat = 0.3
        let warp = SceneGeometry.simulateXYRotation(rotation: .init(x: 0, y: 0, z: 0))
        
        let warpAction = SKAction.warp(to: warp, duration: duration)!
        let rotationAction = SKAction.rotate(
            toAngle: 0,
            duration: duration,
            shortestUnitArc: true
        )

        self.imageContainerNode.run(rotationAction) {
            completion()
        }
        self.imageNode.run(warpAction)
    }
}


// MARK: - Rotation

extension ImageNode {
    func rotate(
        rotation: Rotation,
        axis: RotationAxis,
        around pointInScene: CGPoint
    ) {
        switch axis {
        case .x,
             .y:
            let warp = SceneGeometry.simulateXYRotation(rotation: rotation)
            self.imageNode.warpGeometry = warp
        case .z:
            let pointInNode = self.prepareForTransform(relativeTo: pointInScene)
            self.imageContainerNode.zRotation = rotation.z
            self.cleanUpAfterTranform(initialPointInNode: pointInNode, initialPointInScene: pointInScene)
        }
    }

    func applyRotationZ(
        angle: CGFloat,
        duration: Double,
        around pointInScene: CGPoint,
        completion: @escaping (() -> Void)
    ) {
        guard !self.imageContainerNode.hasActions() else { return }

        let pointInNode = self.prepareForTransform(relativeTo: pointInScene)
        let rotation = SKAction.rotate(toAngle: angle, duration: duration)
        self.imageContainerNode.run(rotation) { [weak self] in
            self?.cleanUpAfterTranform(initialPointInNode: pointInNode, initialPointInScene: pointInScene)
            completion()
        }
    }

    private func prepareForTransform(relativeTo point: CGPoint) -> CGPoint {
        let pointInNode = self.scene!.convert(point, to: self.imageNode)

        guard let scene else { return .zero }
        self.imageContainerNode.position = scene.convert(point, to: self)
        self.imageNode.position = scene.convert(.zero, to: self.imageContainerNode)

        return pointInNode
    }

    private func cleanUpAfterTranform(initialPointInNode: CGPoint, initialPointInScene: CGPoint) {
        guard let scene, let cam = self.scene?.camera else { return }
        self.imageContainerNode.position = .zero
        self.imageNode.position = .zero

        let newPointInScene = scene.convert(initialPointInNode, from: self.imageNode)
        let delta = newPointInScene - initialPointInScene
        cam.position = CGPoint(
            x: cam.position.x + delta.x,
            y: cam.position.y + delta.y
        )
    }
}

// MARK: - Flip

extension ImageNode {
    func mirrorX(relativeTo point: CGPoint) {
        let pointInNode = self.prepareForTransform(relativeTo: point)
        self.xScale *= -1
        self.cleanUpAfterTranform(initialPointInNode: pointInNode, initialPointInScene: point)
    }
}
