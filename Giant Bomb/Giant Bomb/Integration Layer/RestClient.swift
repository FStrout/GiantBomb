//
//  RestClient.swift
//  Giant Bomb
//
//  Created by Fred Strout on 4/19/22.
//

import Foundation

class RestClient {
    let apiKey = "d1c95cbbe827f44c2d4a6eb17556b9427415fff7"
    let baseUrl = "https://www.giantbomb.com/api/games/?api_key="
    let searchUrl = "https://www.giantbomb.com/api/search/?api_key="
    let format = "&format=json"
    func getResponse(searchString: String, completionHandler: @escaping ([Game]) -> Void) {
        var urlString = "\(baseUrl)\(apiKey)\(format)"
        if searchString.count > 0 {
            let formattedSearchString: String = "&query=\"\(searchString.lowercased())\""
            urlString = "\(searchUrl)\(apiKey)\(format)\(formattedSearchString)"
        }
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: escapedString) else {
            print("Houston, we have a problem!")
            return
        }

        print(url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching games: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

            if let unwrappedData = data {
                if let gamesResult = try? JSONDecoder().decode(GamesResult.self, from: unwrappedData) {
                    completionHandler(gamesResult.results)
                }
            }
        })
        task.resume()
      }
}
