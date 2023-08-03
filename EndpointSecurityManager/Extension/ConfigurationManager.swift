//
//  ConfigurationManager.swift
//  extension
//
//  Created by Student2023 on 28.07.2023.

import Foundation

class ConfigurationManager
{
    public func shouldBlockOpen(_ path: String, _ config: Configuration) -> Bool
    {
        for dir in config.directories.directory
        {
            if dir.path == path {
                if dir.open {
                    return true
                }
                else{
                    return false
                }
            }
        }
        return true
    }
    
    public func shouldBlockUnlink(_ path: String, _ config: Configuration) -> Bool
    {
        for dir in config.directories.directory
        {
            if dir.path == path {
                if dir.unlink {
                    return true
                }
                else{
                    return false
                }
            }
        }
        return true
    }
    
    public func shouldBlockRename(_ path: String, _ config: Configuration) -> Bool
    {
        for dir in config.directories.directory
        {
            if dir.path == path {
                if dir.rename {
                    return true
                }
                else{
                    return false
                }
            }
        }
        return true
    }
    
    public func shouldBlockMove(_ path: String, _ config: Configuration) -> Bool
    {
        for dir in config.directories.directory
        {
            if dir.path == path {
                if dir.move {
                    return true
                }
                else{
                    return false
                }
            }
        }
        return true
    }
    
    public func shouldBlockWrite(_ path: String, _ config: Configuration) -> Bool
    {
        for dir in config.directories.directory
        {
            if dir.path == path {
                if dir.write {
                    return true
                }
                else{
                    return false
                }
            }
        }
        return true
    }
    
    public func shouldBlockAllowOpenFrom(_ path: String, _ config: Configuration, _programms: [String]) -> Bool
    {
        return true
    }
}
