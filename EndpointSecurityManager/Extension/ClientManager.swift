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
    static var client: OpaquePointer?
    
    var events = [
        ES_EVENT_TYPE_AUTH_OPEN,
        ES_EVENT_TYPE_AUTH_RENAME,
        ES_EVENT_TYPE_AUTH_UNLINK
    ]

    func initializeClient() {
        let result = es_new_client(&ClientManager.client) { (client, message) in
            HandleEventManager.handleEventMessage(message)
        }
        if result != ES_NEW_CLIENT_RESULT_SUCCESS {
            Logger.log(message: "Failed to create new ES client: \(result)")
        }
    }

    func subscribeToEvents() {
        if let client = ClientManager.client {
            let cacheResult = es_clear_cache(client)
            if cacheResult != ES_CLEAR_CACHE_RESULT_SUCCESS {
                Logger.log(message: "Failed to clear cache")
            }

            let ret = es_subscribe(client, &events, UInt32(events.count))
            if ret != ES_RETURN_SUCCESS {
                Logger.log(message: "Failed to subscribe events")
            }
        }
    }
    
    deinit {
            unsubscribeFromEvents()
            es_delete_client(ClientManager.client)
            ClientManager.client = nil
        }

        func unsubscribeFromEvents() {
            if let client = ClientManager.client {
                let ret = es_unsubscribe(client, &events, UInt32(events.count))
                if ret != ES_RETURN_SUCCESS {
                    Logger.log(message: "Failed to unsubscribe events")
                }
            }
        }
}

