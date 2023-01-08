import Combine
import _PhotosUI_SwiftUI
import Foundation

final class ControlViewModel: ObservableObject {
    
    let output = PassthroughSubject<Output, Never>()
    enum Output {
        case rotate(Rotation, axis: RotationAxis)
        case mirror
        case reset
        case changeImage(data: Data)
    }
    
    @Published var selectedAxis: RotationAxis = .z
    @Published var sliderValue: CGFloat = 0
    @Published var photoPickerItem: PhotosPickerItem? = nil
    private var cancellables = Set<AnyCancellable>()
    private var rotation: Rotation = .init(x: 0, y: 0, z: 0)

    init() {
        self.$sliderValue
            .sink { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch self.selectedAxis {
                    case .x:
                        self.rotation.x = value
                    case .y:
                        self.rotation.y = value
                    case .z:
                        self.rotation.z = value
                    }
                    self.output.send(.rotate(self.rotation, axis: self.selectedAxis))
                }
            }
            .store(in: &cancellables)
        
        self.$selectedAxis
            .sink { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch value {
                    case .x:
                        self.sliderValue = self.rotation.x
                    case .y:
                        self.sliderValue = self.rotation.y
                    case .z:
                        self.sliderValue = self.rotation.z
                    }
                }
            }
            .store(in: &cancellables)
        
        self.$photoPickerItem
            .sink { [weak self] item in
                let output = self?.output
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self) {
                        output?.send(.changeImage(data: data))
                    }
                }
                
            }
            .store(in: &cancellables)
    }
}
