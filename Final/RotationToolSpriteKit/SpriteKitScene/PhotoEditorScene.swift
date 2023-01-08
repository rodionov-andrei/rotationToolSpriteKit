import SpriteKit
import Foundation
import Combine

final class PhotoEditorScene: SKScene {
    
    private let imageNode: ImageNode
    private let cameraNode = SKCameraNode()
    private var subscriptions = Set<AnyCancellable>()
    
    init(controlsOutput: PassthroughSubject<ControlViewModel.Output, Never>) {
        self.imageNode = ImageNode(texture: SKTexture(image: UIImage(named: "default_img")!))
        
        super.init(size: .zero)
        
        self.camera = self.cameraNode
        self.addChild(self.cameraNode)
        self.addChild(self.imageNode)
        
        self.backgroundColor = .clear
        self.subscribeOnControlsOutput(controlsOutput)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        self.imageNode.adjustSize(self.size)
    }
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setupGestures(to: view)
    }
    
    private func setupGestures(to view: SKView) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.onZoom(_:)))
        view.addGestureRecognizer(pinchGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onDrag(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)
    }
    
    private lazy var zoomBehavior = ZoomBehavior(
        scene: self,
        cameraNode: self.cameraNode,
        onComplete: { [weak self] in  }
    )
    
    private lazy var dragBehavior = DragBehavior(
        scene: self,
        cameraNode: self.cameraNode,
        onComplete: { [weak self] in
            //
        }
    )
    
    @objc private func onZoom(_ sender: UIPinchGestureRecognizer) {
        self.zoomBehavior.handle(sender)
    }

    @objc private func onDrag(_ sender: UIPanGestureRecognizer) {
        self.dragBehavior.handle(sender)
    }
}

// MARK: - Input

extension PhotoEditorScene {
    private func subscribeOnControlsOutput(_ output: PassthroughSubject<ControlViewModel.Output, Never>) {
        output.sink { [weak self] value in
            guard let self else { return }
            switch value {
            case .reset:
                self.imageNode.reset() {
                    let duration: CGFloat = 0.3
                    let scaleAction = SKAction.scale(to: 1, duration: duration)
                    let moveAction = SKAction.move(to: .zero, duration: duration)
                    self.cameraNode.run(.group([scaleAction, moveAction]))
                }
            case .mirror:
                guard let view = self.view else { return }
                self.imageNode.mirrorX(relativeTo: self.convertPoint(fromView: view.center))
            case let .rotate(rotation, axis):
                guard let view = self.view else { return }
                self.imageNode.rotate(rotation: rotation.rad, axis: axis, around: self.convertPoint(fromView: view.center))
            case let .changeImage(imageData):
                if let image = UIImage(data: imageData) {
                    self.imageNode.setTexture(SKTexture(image: image))
                }
            }
        }
        .store(in: &subscriptions)
    }
}

final class PhotoEditorView: SKView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.scene?.size = self.frame.size
    }
}
