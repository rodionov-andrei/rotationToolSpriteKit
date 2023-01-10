//
//  ContentView.swift
//  RotationToolSpriteKit
//
//  Created by Andrey Rodionov on 31.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    private let controlsViewModel = ControlViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                SceneSwiftUIView(controlsOutput: self.controlsViewModel.output)
                
                ControlView(viewModel: self.controlsViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
