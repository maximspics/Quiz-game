//
//  NetworkDataFetcher.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 01.11.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchQuestions(urlString: String, response: @escaping ([QuestionsCategory]?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let questions = try JSONDecoder().decode([QuestionsCategory].self, from: data)
                    response(questions)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
