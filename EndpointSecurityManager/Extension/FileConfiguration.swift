//
//  FileConfiguration.swift
//  Extension
//
//  Created by Student2023 on 03.08.2023.
//

import Foundation
import os.log

struct Configuration: Codable
{
    struct Directories: Codable
    {
        struct Directory: Codable
        {
            let path: String;
            let open: Bool;
            let write: Bool;
            let allow_open_from: [String];
            let unlink: Bool;
            let rename: Bool;
            let move: Bool;
        }
        let directory: [Directory]
    }
    let directories: Directories;
}

class FileConfiguration
{
    static func getConfiguration(_ inputJSON: String) -> Configuration?
    {
        guard let json = inputJSON.data(using: .utf8) else {
            os_log("Invalid input json")
            return nil
        }
        let decoder = JSONDecoder()
        if let configuration = try? decoder.decode(Configuration.self, from: json) {
            return configuration
        }
        else {
            os_log("Json file is incorrect")
            return nil
        }
    }
}
