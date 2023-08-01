//
//  ConfigurationManager.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.
import Foundation
import EndpointSecurity

struct FileMessage {
    let fileName: String
    let message: String
}

class ConfigurationManager {
    let events: [String]
    let openedFiles: [FileMessage]
    let unlinkedFiles: [FileMessage]
    let renamedFiles: [FileMessage]

    init?(jsonFileName: String) {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return nil
        }
        
        guard let events = json["events"] as? [[String: Any]] else {
            return nil
        }
        
        self.events = events.compactMap { event in
            return event["type"] as? String
        }
        
        var openFiles = [FileMessage]()
        var renamedFiles = [FileMessage]()
        var unlinkedFiles = [FileMessage]()

        for event in events {
            guard let eventType = event["type"] as? String, let files = event["files"] as? [[String: String]] else {
                continue
            }
            
            for file in files {
                guard let fileName = file["file"], let message = file["message"] else {
                    continue
                }
                
                let fileMessage = FileMessage(fileName: fileName, message: message)
                if eventType == "ES_EVENT_TYPE_AUTH_OPEN" {
                    openFiles.append(fileMessage)
                }  else if eventType == "ES_EVENT_TYPE_AUTH_UNLINK" {
                    unlinkedFiles.append(fileMessage)
                } else if eventType == "ES_EVENT_TYPE_AUTH_RENAME" {
                    renamedFiles.append(fileMessage)
                } 
            }
        }
        
        self.openedFiles = openFiles
        self.unlinkedFiles = unlinkedFiles
        self.renamedFiles = renamedFiles
        
    }
}


