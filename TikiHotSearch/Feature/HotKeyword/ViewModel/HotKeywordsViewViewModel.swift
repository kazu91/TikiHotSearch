//
//  HotKeywordsViewViewModel.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation

class HotKeywordsViewViewModel: ObservableObject {
    
    let keywordService: KeywordServiceProtocol
    
    @Published var keywordList: [Keyword] = []
    @Published var isLoading: Bool = false
    @Published var isShowingError = false
    
    private var tasks: [Task<Void, Never>] = []
    
    init(keywordService: KeywordServiceProtocol = KeywordService(apiClient: URLSessionAPIClient<KeywordEndpoint>())) {
        self.keywordService = keywordService
    }
    
    deinit {
        tasks.forEach({ $0.cancel() })
    }
    
    var errorMessage = ""
    
    @MainActor
    func getKeywordList() async {
        do {
            isLoading = true
            defer { isLoading = false }
            
            let keywordList: KeywordListResponse = try await keywordService.getHotKeywords()
            
            self.keywordList = keywordList.items
            
        }  catch {
            switch error {
            case APIError.serverError:
                errorMessage = "Please try again later!"
            case APIError.clientError(let message):
                errorMessage = message
            default: break
            }
            isShowingError = true
            print(error.localizedDescription)
        }
    }
    
}
