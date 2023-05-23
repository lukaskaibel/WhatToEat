//
//  DownloadImage.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation
import OSLog
import Combine

func downloadImage(from url: URL) -> AnyPublisher<URL, Error> {
    let session = URLSession.shared
    let fileManager = FileManager.default
    let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.whatToEat")
    
    guard let safeGroupURL = groupURL else {
        return Fail(error: NSError(domain: "Shared container not found", code: 0, userInfo: nil)).eraseToAnyPublisher()
    }
    
    Logger().log("Starting to download image from url: \(url)")
    return session.downloadTaskPublisher(for: url)
        .tryMap { location, _ -> URL in
            let imagesFolderURL = safeGroupURL.appendingPathComponent("DownloadedImages")
            
            // Create the DownloadedImages folder if it doesn't exist
            if !fileManager.fileExists(atPath: imagesFolderURL.path) {
                try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
            }

            let destinationURL = imagesFolderURL.appendingPathComponent(url.lastPathComponent)

            do {
                try fileManager.moveItem(at: location, to: destinationURL)
                Logger().log("Successfully downloaded image")
                return destinationURL
            } catch {
                Logger().error("Error while downloading image: \(error)")
                throw error
            }
        }
        .eraseToAnyPublisher()
}


