//
//  DownloadImage.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation
import OSLog

func downloadImage(from url: URL) async throws -> URL {
    let session = URLSession.shared
    let (location, _) = try await session.download(from: url)

    let fileManager = FileManager.default
    guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.whatToEat") else {
        throw NSError(domain: "Shared container not found", code: 0, userInfo: nil)
    }
    
    let imagesFolderURL = groupURL.appendingPathComponent("DownloadedImages")
    
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

