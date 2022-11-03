//
//  GetEnglishToTurkish.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.10.2022.
//

import Foundation

protocol EnglishToTurkishUseCaseProtocol {
    func getEnglishToTurkishWord(completionHandler: (Result<CardModel,Error>))
}

class EnglishToTurkishUseCase {
    
    let repo: EnglishToTurkishRepositoryProtocol
    
    init(repo: EnglishToTurkishRepositoryProtocol) {
        self.repo = repo
    }
    
}

extension EnglishToTurkishUseCase: EnglishToTurkishUseCaseProtocol {
    func getEnglishToTurkishWord(completionHandler: (Result<CardModel, Error>)) {
        
    }
}
