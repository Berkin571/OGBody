//
//  PlanResponse.swift
//  OG-Body
//
//  Created by Berkin Koray Bilgin on 08.05.25.
//

import Foundation

struct OpenAIChoice: Decodable {
    let text: String
}

struct PlanResponse: Decodable {
    let choices: [OpenAIChoice]
}
