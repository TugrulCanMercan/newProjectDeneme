//
//  DIManager.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.10.2022.
//

import Foundation
import Swinject
import MyInfrastructures

final class DIManager {
    
    static let shared = DIManager()
    let container: Container
    private init() {
        self.container = Container()
        
        container.register(NetworkConfigurable.self, name: "IBaseApıConfig") { _ in
            let baseUrl = URL(string: "http://localhost:5001")!
            return ApiDataNetworkConfig(baseURL: baseUrl)
        }
        
        container.register(NetworkService.self, name: "INetworkService") { resolver in
            
            return DefaultNetworkService(config: resolver.resolve(NetworkConfigurable.self, name: "IBaseApıConfig")!)
        }
        container.register(DataTransferService.self, name: "IDataTransferService") { resolver in
            let dataTransferErrorLogger = DefaultDataTransferErrorLogger()
            //DataDefaultResolver Enumla değişcek
            let dataTransferErrorResolver = DefaultDataTransferErrorResolver()
            return DefaultDataTransferService(with: resolver.resolve(NetworkService.self, name: "INetworkService")!, errorResolver: dataTransferErrorResolver, errorLogger: dataTransferErrorLogger)
        }
        container.register(DataTransferService.self, name: "IDataHerokuApi") { resolver in
            let dataTransferErrorLogger = DefaultDataTransferErrorLogger()
            let baseUrl = URL(string: "https://new-english-app.herokuapp.com/")!
            let baseConfig = ApiDataNetworkConfig(baseURL: baseUrl)
            let defaultService = DefaultNetworkService(config: baseConfig)
            let dataTransferErrorResolver = DefaultDataTransferErrorResolver()
            
            return DefaultDataTransferService(with: defaultService, errorResolver: dataTransferErrorResolver, errorLogger: dataTransferErrorLogger)
        }
    }
}
