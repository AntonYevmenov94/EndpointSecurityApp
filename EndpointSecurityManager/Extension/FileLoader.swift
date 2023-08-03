//
//  FileLoader.swift
//  EndpointSecurityApp
//
//  Created by Student2023 on 30.07.2023.
//

import Foundation

class FileLoader
{
    static func load(_ name: String) -> String?
    {
        do
        {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json")
            {
                let jsonData = try String(contentsOfFile: bundlePath, encoding: .utf8);
                return jsonData;
            }
            else
            {
                return "Failed open file";
            }
        }
        catch{
            print(error);
        }
        return nil;
    }
}


