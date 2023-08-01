//
//  main.swift
//  Extension
//
//  Created by Student2023 on 31.07.2023.
//


import Foundation
import EndpointSecurity


let configurationManager = ConfigurationManager(jsonFileName: "configuration")
guard let config = configurationManager else {
    fatalError("Failed to load configuration from JSON")
}



let clientManager = ClientManager()
clientManager.initializeClient()
clientManager.subscribeToEvents()

dispatchMain()
