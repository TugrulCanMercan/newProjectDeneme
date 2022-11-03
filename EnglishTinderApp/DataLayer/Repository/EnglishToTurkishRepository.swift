//
//  EnglishToTurkishRepository.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.10.2022.
//

import Foundation
import MyInfrastructures


final class EnglishToTurkishRepository: BaseRepository, EnglishToTurkishRepositoryProtocol {
    func getWord(completionHandler: @escaping (Result<CardModel,Error>) -> Void ) {
        let requesT = APIEndpoint.EnglishToTurkishTinderEndpoint.getEnglisToTurkish()
        networkService.request(with: requesT) { result in
            
        }
    }
    
}


protocol BaseRepository {
    var networkService: DataTransferService { get set }
    init(networkService:DataTransferService)
}
extension BaseRepository {
    var networkService: DataTransferService {
        get {
            return DIManager.shared.container.resolve(DataTransferService.self, name: "IDataTransferService")!
        }
        set {
            networkService = newValue
        }
    }
    init(networkService:DataTransferService) {
        self.networkService = networkService
    }
}
