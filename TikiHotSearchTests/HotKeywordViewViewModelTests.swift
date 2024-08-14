//
//  HotKeywordViewViewModelTests.swift
//  TikiHotSearchTests
//
//  Created by Kazu on 14/8/24.
//

import Foundation
import XCTest


class HotKeywordViewViewModelTests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    var keywordService: KeywordService<MockAPIClient>!
    
    let listResponse: KeywordListResponse = .init(items: [
        Keyword(icon: "icon1.png", name: "Samsung"),
        Keyword(icon: "icon2.png", name: "Apple")
    ])
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        keywordService = KeywordService(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIClient = nil
        keywordService = nil
    }
    
    func testGetSurveyListSuccess() async throws {
        let viewModel = HotKeywordsViewViewModel(
            keywordService: keywordService
        )
        
        mockAPIClient.result = .success(listResponse)
        
        await viewModel.getKeywordList()
        
        XCTAssertEqual(viewModel.keywordList.count, 2, "Expected 2 surveys in the list")
        XCTAssertEqual(viewModel.keywordList[0].name, "Samsung", "Expected Samsung")
        XCTAssertEqual(viewModel.keywordList[1].icon, "icon2.png", "Expected icon2.png")
    }
    
    func testGetSurveyListFailure() async {
        mockAPIClient.result = .failure(.serverError)
        
        let viewModel = HotKeywordsViewViewModel(
            keywordService: keywordService
        )
        
        await viewModel.getKeywordList()
        let errorMessage = viewModel.errorMessage
        
        XCTAssertEqual(errorMessage, "Please try again later!")
        
    }
    
    func testGetSurveyListClientFailure() async {
        mockAPIClient.result = .failure(.clientError(message: "Test Client Message"))
        let viewModel = HotKeywordsViewViewModel(
            keywordService: keywordService
        )
        
        await viewModel.getKeywordList()
        let errorMessage = viewModel.errorMessage
        
        XCTAssertEqual(errorMessage, "Test Client Message")
    }
}
