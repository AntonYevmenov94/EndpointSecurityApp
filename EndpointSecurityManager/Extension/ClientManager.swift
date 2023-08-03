//
//  ClientManager.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.
//

import Foundation
import EndpointSecurity
import OSLog

class ClientManager {
    private var client: OpaquePointer?
    
    private let events = [
        ES_EVENT_TYPE_AUTH_OPEN,
        ES_EVENT_TYPE_AUTH_RENAME,
        ES_EVENT_TYPE_AUTH_UNLINK
    ]

    public func initializeClient() {
        let eventHandler = HandleEventManager()
        let result = es_new_client(&client) { (client, message) in
            eventHandler.handleEventMessage(client, message)
        }
        if result != ES_NEW_CLIENT_RESULT_SUCCESS {
            Logger.log(message: "Failed to create new ES client: \(result)")
        }
    }

    public func subscribeToEvents() {
        guard let client = client else {
            Logger.log(message: "Client is nil")
            return
        }
        
        let cacheResult = es_clear_cache(client)
        guard cacheResult == ES_CLEAR_CACHE_RESULT_SUCCESS else {
            Logger.log(message: "Failed to clear cache")
            return
        }
        
        let ret = es_subscribe(client, events, UInt32(events.count))
        guard ret == ES_RETURN_SUCCESS else {
            Logger.log(message: "Failed to subscribe events")
            return
        }
    }
    
    deinit {
        unsubscribeFromEvents()
        es_delete_client(client)
        client = nil
    }
    
    private func unsubscribeFromEvents() {
        guard let client = client else {
            Logger.log(message: "Client is nil")
            return
        }
        let ret = es_unsubscribe(client, events, UInt32(events.count))
        guard ret == ES_RETURN_SUCCESS else {
            Logger.log(message: "Failed to unsubscribe events")
            return
        }
    }
}

