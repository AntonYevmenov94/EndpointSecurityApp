//
//  Logger.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.
//

import Foundation
import OSLog

class Logger {
    static func log(message: String) {
        os_log("%{public}s", log: .default, message)
    }
}
