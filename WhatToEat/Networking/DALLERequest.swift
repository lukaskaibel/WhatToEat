//
//  DALLERequest.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import OSLog
import UIKit

public func makeDALLERequest(for prompt: String) async throws -> URL? {
    let url = URL(string: "https://api.openai.com/v1/images/generations")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
    
    let requestBody = [
        "model": "image-alpha-001",
        "prompt": "\(prompt)",
        "num_images": 1,
        "size": "1024x1024"
    ] as [String : Any]
    let requestBodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    request.httpBody = requestBodyData
    
    Logger().log("DALLE Request with body: \(requestBodyData.debugDescription)")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        let responseStatus = (response as? HTTPURLResponse)?.statusCode ?? -1
        Logger().error("DALLE request failed with status \(responseStatus)")
        throw NSError(domain: "DALLE request failed with status \(responseStatus)", code: responseStatus, userInfo: nil)
    }
    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    guard let urlString = (jsonResponse?["data"] as? [[String: Any]])?.first?["url"] as? String else { return nil }
    let imageUrl = URL(string: urlString)
    return imageUrl
}
