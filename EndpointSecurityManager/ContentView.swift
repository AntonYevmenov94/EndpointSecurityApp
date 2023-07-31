//
//  ContentView.swift
//  EndpointSecurityManager
//
//  Created by Student2023 on 31.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var disableFileOpening = false
    @State private var disableFileRenaming = false
    @State private var disableFileUnlinking = false
    
    var body: some View {
        VStack {
            // Add the text fields and toggle switches here
            TextField("Enter directory or file path here", text: .constant(""))
                .padding()
            
            Toggle("Disable File Opening", isOn: $disableFileOpening)
                .padding()
            
            Toggle("Disable File Renaming", isOn: $disableFileRenaming)
                .padding()
            
            Toggle("Disable File Unlinking", isOn: $disableFileUnlinking)
                .padding()

            // Add the buttons for Install and Uninstall Extension
            Button("Update Extension") {
                
            }
            Button("Install Extension") {
                let endpointManager = EndpointManager()
                endpointManager.installExtension()
            }
            
            Button("Uninstall Extension") {
                let endpointManager = EndpointManager()
                endpointManager.uninstallExtension()
            }
        }
        .frame(width: 500, height: 400) // Устанавливаем размеры
        .background(Color.white) // Добавляем белый фон для отображения контента по центру
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
