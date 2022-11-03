//
//  EnglishToTurkishDTO.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.10.2022.
//

import Foundation

struct EnglishToTurkishDTO: Codable {
    let ID: Int?
    let Word: String?
    let turkish: String?
}

extension EnglishToTurkishDTO {
    func toDomain() ->  {
        
    }
}
