//
//  HandleEventManager.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.
//

import Foundation
import os.log
import EndpointSecurity

class HandleEventManager {
    private func openEventHandle(_ client: OpaquePointer, _ msg: UnsafePointer<es_message_t>, _ configuration: Configuration, _ configurationManager: ConfigurationManager)
    {
        guard let filePath = msg.pointee.event.open.file.pointee.path.data else {
            Logger.log(message: "Open event: filePath is nil")
            return
        }
        let file_path_string = String(cString: filePath)
        if configurationManager.shouldBlockOpen(file_path_string, configuration) {
            os_log("File OPENING BLOCKED:  %{public}@", file_path_string)
            es_respond_flags_result(client, msg, 0, false);
        }
        else {
            es_respond_flags_result(client, msg, 0xffffffff, false);
        }
        
//        var k = 1
//        if configurationManager?.openedFiles != nil
//        {
//            for fileMessage in configurationManager!.openedFiles {
//                let fileName = fileMessage.fileName
//                if fileString.contains(fileName) {
//                    Logger.log(message: "File OPENING BLOCKED \(fileMessage.message)")
//                    es_respond_flags_result(client, msg, 0, false);
//                    k+=1
//                }
//
//            }
//        }
//        if k == 1
//        {
//            es_respond_flags_result(client, msg, 0xffffffff, false);
//        }
    }
    
//    private func unlinkEventHandle(_ client: OpaquePointer, _ msg: UnsafePointer<es_message_t>)
//    {
//        guard let filePath = msg.pointee.event.unlink.target.pointee.path.data else {
//            Logger.log(message: "Unlink event: filePath is nil")
//            return
//        }
//        let fileString = String(cString: filePath)
//        var k = 1
//        if configurationManager?.unlinkedFiles != nil {
//            for fileMessage in configurationManager!.unlinkedFiles {
//                let fileName = fileMessage.fileName
//                if fileString.contains(fileName) {
//                    Logger.log(message: "File unlinked: \(fileMessage.message)")
//                    es_respond_auth_result(client, msg, ES_AUTH_RESULT_DENY, false);
//                    k+=1
//                }
//            }
//        }
//        if k == 1
//        {
//            es_respond_auth_result(client, msg, ES_AUTH_RESULT_ALLOW, false);
//        }
//    }
//
//    private func renameEventHandle(_ client: OpaquePointer, _ msg: UnsafePointer<es_message_t>)
//    {
//        guard let filePath = msg.pointee.event.rename.source.pointee.path.data else {
//            Logger.log(message: "Rename event: filePath is nil")
//            return
//        }
//        let fileString = String(cString: filePath)
//        var k = 1
//        if configurationManager?.renamedFiles != nil {
//            for fileMessage in configurationManager!.renamedFiles {
//                let fileName = fileMessage.fileName
//                if fileString.contains(fileName) {
//                    Logger.log(message: "File RENAME BLOCKED: \(fileString)")
//                    es_respond_auth_result(client, msg, ES_AUTH_RESULT_DENY, false);
//                    k+=1
//                }
//
//            }
//        }
//        if k == 1
//        {
//            es_respond_auth_result(client, msg, ES_AUTH_RESULT_ALLOW, false);
//        }
//    }
    
    public func handleEventMessage(_ client: OpaquePointer, _ msg: UnsafePointer<es_message_t>) {
        
        guard let jsonData: String = FileLoader.load("data") else {
            os_log("Failed load json file")
            return
        }
        guard let configuration = FileConfiguration.getConfiguration(jsonData) else {
            os_log("Failed to get configuration")
            return
        }
        let configurationManager = ConfigurationManager()
        
        switch msg.pointee.event_type {
        case ES_EVENT_TYPE_AUTH_OPEN:
            openEventHandle(client, msg, configuration, configurationManager)
            break
//        case ES_EVENT_TYPE_AUTH_UNLINK:
//            unlinkEventHandle(client, msg)
//            break
//        case ES_EVENT_TYPE_AUTH_RENAME:
//            renameEventHandle(client, msg)
//            break
        default:
            Logger.log(message: "Unexpected event type encountered: \(msg.pointee.event_type.rawValue)")
            break
        }
    }
}
