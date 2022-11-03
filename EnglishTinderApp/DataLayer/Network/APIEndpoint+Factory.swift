//
//  APIEndpoint+Factory.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 3.10.2022.
//

import Foundation
import MyInfrastructures

struct APIEndpoint {
    
    enum EnglishToTurkishTinderEndpoint {
        static func getEnglisToTurkish() -> Endpoint<EnglishToTurkishDTO> {
            return Endpoint(path: "", method: .get )
        }
    }
}
