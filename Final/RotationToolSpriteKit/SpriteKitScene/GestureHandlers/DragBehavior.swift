import Foundation
import SpriteKit
import UIKit

final class DragBehavior {
    // MARK: Lifecycle

    init(
        scene: PhotoEditorScene,
        cameraNode: SKCameraNode,
        onComplete: (() -> Void)?
    ) {
        self.scene = scene
        self.cameraNode = cameraNode
        self.onComplete = onComplete
    }

    func handle(_ sender: UIPanGestureRecognizer) {
        guard let scene = self.scene else {
            return
        }
        // Convert gesture location from view to scene
        let location = scene.convertPoint(fromView: sender.location(in: sender.view))

        switch sender.state {
        case .began:
            self.startLocation = location
        case .changed:
            let translation = location - self.startLocation
            self.cameraNode.position += translation * -1
        case .cancelled,
             .failed,
             .ended:
            self.onComplete?()
        default:
            break
        }
    }

    // MARK: Private

    private weak var scene: PhotoEditorScene?
    private let cameraNode: SKCameraNode
    private var onComplete: (() -> Void)?

    private var startLocation: CGPoint = .zero
}
