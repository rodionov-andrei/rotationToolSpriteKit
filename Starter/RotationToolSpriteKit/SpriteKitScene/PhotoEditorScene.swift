import SpriteKit
import Foundation
import Combine

final class PhotoEditorScene: SKScene {
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(controlsOutput: PassthroughSubject<ControlViewModel.Output, Never>) {
        super.init(size: .zero)
        
        self.backgroundColor = .clear
        self.subscribeOnControlsOutput(controlsOutput)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Input

extension PhotoEditorScene {
    private func subscribeOnControlsOutput(_ output: PassthroughSubject<ControlViewModel.Output, Never>) {
        output.sink { [weak self] value in
            guard let self else { return }
            switch value {
            case .reset:
                // TODO: reset all edits
                break
            case .mirror:
                // TODO: mirro x
                break
            case let .rotate(rotation, axis):
                // TODO: rotate
                break
            case let .changeImage(imageData):
                // TODO: load new image
                break
            }
        }
        .store(in: &subscriptions)
    }
}

final class PhotoEditorView: SKView {
    
}
