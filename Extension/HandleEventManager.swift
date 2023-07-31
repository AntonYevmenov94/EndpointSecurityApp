//
//  HandleEventManager.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.
//

import Foundation
import OSLog
import EndpointSecurity

class HandleEventManager {
    
    
    static func handleEventMessage(_ msg: UnsafePointer<es_message_t>) {
        switch msg.pointee.event_type {

            
        case ES_EVENT_TYPE_AUTH_OPEN:
        
            if let filePath = msg.pointee.event.open.file.pointee.path.data {
                        let fileString = String(cString: filePath)
                        var k = 1
                        if configurationManager?.openedFiles != nil
                        {
                            for fileMessage in configurationManager!.openedFiles {
                                let fileName = fileMessage.fileName
                                if fileString.contains(fileName) {
                                    Logger.log(message: "File OPENING BLOCKED \(fileMessage.message)")
                                    es_respond_flags_result(ClientManager.client!, msg, 0, false);
                                    k+=1
                                }
                                                              
                            }
                        }
                        if k == 1
                        {
                            es_respond_flags_result(ClientManager.client!, msg, 0xffffffff, false);
                        }
                    }
            
            
        case ES_EVENT_TYPE_AUTH_UNLINK:
            if let filePath = msg.pointee.event.unlink.target.pointee.path.data {
                let fileString = String(cString: filePath)
                var k = 1
                if configurationManager?.unlinkedFiles != nil {
                    for fileMessage in configurationManager!.unlinkedFiles {
                        let fileName = fileMessage.fileName
                        if fileString.contains(fileName) {
                            Logger.log(message: "File unlinked: \(fileMessage.message)")
                            es_respond_auth_result(ClientManager.client!, msg, ES_AUTH_RESULT_DENY, false);
                            k+=1
                        }
                                                      
                    }
                }
                if k == 1
                {
                    es_respond_auth_result(ClientManager.client!, msg, ES_AUTH_RESULT_ALLOW, false);
                }
            }
            

        case ES_EVENT_TYPE_AUTH_RENAME:
         
            if let filePath = msg.pointee.event.rename.source.pointee.path.data
            {
                let fileString = String(cString: filePath)
                var k = 1
                if configurationManager?.renamedFiles != nil {
                    for fileMessage in configurationManager!.renamedFiles {
                        let fileName = fileMessage.fileName
                        if fileString.contains(fileName) {
                            Logger.log(message: "File RENAME BLOCKED: \(fileString)")
                            es_respond_auth_result(ClientManager.client!, msg, ES_AUTH_RESULT_DENY, false);
                            k+=1
                        }
                                                      
                    }
                }
                if k == 1
                {
                    es_respond_auth_result(ClientManager.client!, msg, ES_AUTH_RESULT_ALLOW, false);
                }
            }

            
    
        default:
            Logger.log(message: "Unexpected event type encountered: \(msg.pointee.event_type.rawValue)")
        }
    }
}
