import Foundation
import SpriteKit
import UIKit

final class ZoomBehavior {
    // MARK: Lifecycle

    init(
        scene: SKScene,
        cameraNode: SKCameraNode,
        onComplete: (() -> Void)?
    ) {
        self.scene = scene
        self.cameraNode = cameraNode
        self.onComplete = onComplete
    }

    // MARK: Internal

    func handle(_ sender: UIPinchGestureRecognizer) {
        guard let scene = self.scene else {
            return
        }

        let location = scene.convertPoint(fromView: sender.location(in: sender.view))

        let scale = self.startScale * 1 / sender.scale

        switch sender.state {
        case .began:
            self.startScale = self.cameraNode.xScale
            self.startLocation = location
        case .changed:
            guard sender.numberOfTouches == 2 else { return }

            let translation = location - self.startLocation
            self.cameraNode.position += translation * -1
            self.cameraNode.setScale(scale)
        case .cancelled,
             .failed,
             .ended:
            self.onComplete?()
        default:
            break
        }
    }

    // MARK: Private

    private weak var scene: SKScene?
    private let cameraNode: SKCameraNode
    private var onComplete: (() -> Void)?

    private var startScale: CGFloat = 1
    private var startLocation: CGPoint = .zero
}
