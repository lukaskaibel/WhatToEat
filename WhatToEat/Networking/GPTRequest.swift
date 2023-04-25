//
//  GPTRequest.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import os.log

func makeGptRequest(prompt: String, maxTokens: Int = 1024) async throws -> String? {
    do {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        let requestBody = ["model": "text-davinci-003",
                            "prompt": "\(prompt)",
                            "max_tokens": maxTokens] as [String : Any]
        let requestBodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = requestBodyData
        
        Logger().log("GPT Request with body: \(requestBodyData.debugDescription)")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let responseStatus = (response as? HTTPURLResponse)?.statusCode ?? -1
            Logger().error("GPT request failed with status \(responseStatus)")
            throw NSError(domain: "GPT request failed with status \(responseStatus)", code: responseStatus, userInfo: nil)
        }
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let text = (jsonResponse?["choices"] as? [[String: Any]])?.first?["text"] as? String
        return text
    } catch {
        Logger().error("Error: \(error.localizedDescription)")
        throw error
    }
}
