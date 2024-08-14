//
//  TikiHotSearchApp.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import SwiftUI
import SwiftData

@main
struct TikiHotSearchApp: App {
    var body: some Scene {
        WindowGroup {
            HotKeywordView(viewModel: HotKeywordsViewViewModel())
        }
    }
}
