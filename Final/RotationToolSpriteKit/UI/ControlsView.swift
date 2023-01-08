import SwiftUI
import PhotosUI

struct ControlView: View {
    
    @StateObject var viewModel: ControlViewModel
    
    var body: some View {
        VStack {
            mirrorAndReset
            rotationButtons
            slider
        }
        .background {
            Color(uiColor: UIColor.darkGray)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .ignoresSafeArea()
        }
    }
    
    private var mirrorAndReset: some View {
        HStack {
                Button(action: {self.viewModel.output.send(.mirror)}, label: {controlImage("mirror")})
                Spacer()
                PhotosPicker(
                    selection: $viewModel.photoPickerItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Select Image")
                    }
                    .controlSize(.small)
                
                Spacer()
                Button("Reset", action: {self.viewModel.output.send(.reset)})
        }
        .padding(.horizontal, 40)
        .padding()
    }
    
    private var rotationButtons: some View {
        HStack(spacing: 40) {
            Button {
                self.viewModel.selectedAxis = .x
            } label: {
                rotationButton(
                    "x", "rotateX",
                    isSelected: self.viewModel.selectedAxis == .x
                )
            }
            Button {
                self.viewModel.selectedAxis = .z
            } label: {
                rotationButton(
                    "z", "rotateZ",
                    isSelected: self.viewModel.selectedAxis == .z
                )
            }
            Button {
                self.viewModel.selectedAxis = .y
            } label: {
                rotationButton(
                    "y", "rotateY",
                    isSelected: self.viewModel.selectedAxis == .y
                )
            }
        }
    }
    
    private var slider: some View {
        Slider(value: $viewModel.sliderValue, in: -45...45, step: 1) {
        } minimumValueLabel: {
            Text("-45").font(.title2).fontWeight(.thin)
        } maximumValueLabel: {
            Text("45").font(.title2).fontWeight(.thin)
        }
        .foregroundColor(.white)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }
    
    private func controlImage(_ name: String) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
    }
    
    private func rotationButton(_ title: String, _ imgName: String, isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                Color.green
                    .opacity(0.6)
                    .frame(width: 30, height: 50)
                    .cornerRadius(8)
            }
                
            VStack(spacing: .zero) {
                controlImage(imgName)
                Text(title)
                    .foregroundColor(.white)
            }
        }
    }
}
