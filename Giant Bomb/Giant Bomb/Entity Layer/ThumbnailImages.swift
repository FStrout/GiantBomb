//
//  ThumbnailImages.swift
//  Giant Bomb
//
//  Created by Fred Strout on 4/19/22.
//

import Foundation

class ThumbnailImages: Codable {
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case url = "thumb_url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(URL.self, forKey: .url)
    }
    
}
