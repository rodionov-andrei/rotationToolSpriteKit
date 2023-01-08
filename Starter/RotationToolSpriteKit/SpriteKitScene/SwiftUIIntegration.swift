import SwiftUI
import SpriteKit
import Combine

struct SceneSwiftUIView: UIViewRepresentable {
    
    init(controlsOutput: PassthroughSubject<ControlViewModel.Output, Never>) {
        self.controlsOutput = controlsOutput
    }
    
    func makeUIView(context: Context) -> SKView {
        let v = PhotoEditorView()
        v.backgroundColor = .clear
        let scene = PhotoEditorScene(controlsOutput: self.controlsOutput)
        v.presentScene(scene)
        return v
    }
    
    func updateUIView(_ scene: SKView, context: Context) {
        
    }
    
    private let controlsOutput: PassthroughSubject<ControlViewModel.Output, Never>
}
