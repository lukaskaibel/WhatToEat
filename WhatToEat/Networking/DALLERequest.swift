//
//  DALLERequest.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import OSLog
import Combine


public func makeDALLERequest(for prompt: String) -> AnyPublisher<URL, Error> {
    let url = URL(string: "https://api.openai.com/v1/images/generations")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(OPENAI_API_KEY)", forHTTPHeaderField: "Authorization")

    let requestBody = [
        "model": "image-alpha-001",
        "prompt": "\(prompt)",
        "num_images": 1,
        "size": "1024x1024"
    ] as [String : Any]
    let requestBodyData = try! JSONSerialization.data(withJSONObject: requestBody, options: [])
    request.httpBody = requestBodyData

    Logger().log("DALLE Request with body: \(requestBodyData.debugDescription)")

    return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let responseStatus = (response as? HTTPURLResponse)?.statusCode ?? -1
                Logger().error("DALLE request failed with status \(responseStatus)")
                throw NSError(domain: "DALLE request failed with status \(responseStatus)", code: responseStatus, userInfo: nil)
            }
            return data
        }
        .tryMap { data -> [String: Any] in
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonResponse
            } else {
                throw NSError(domain: "Error: JSON decoding failed", code: -1, userInfo: nil)
            }
        }
        .mapError { error -> Error in
            Logger().error("Error: \(error.localizedDescription)")
            return error
        }
        .tryMap { jsonResponse -> URL in
            if let urlString = (jsonResponse["data"] as? [[String: Any]])?.first?["url"] as? String,
               let imageUrl = URL(string: urlString) {
                Logger().log("Received DALLE response with image URL: \(imageUrl)")
                return imageUrl
            } else {
                throw NSError(domain: "Error: DALLE response parsing failed", code: -1, userInfo: nil)
            }
        }
        .eraseToAnyPublisher()
}

