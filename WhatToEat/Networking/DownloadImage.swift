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
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
    
    do {
        try fileManager.moveItem(at: location, to: destinationURL)
        Logger().log("Successfully downloaded image")
        return destinationURL
    } catch {
        Logger().error("Error while downloading image: \(error)")
        throw error
    }
}
