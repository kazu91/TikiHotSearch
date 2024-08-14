//
//  HotKeywordView.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HotKeywordView: View {
    
    let imageWidth: CGFloat = 120
    let titlePadding: CGFloat = 8
    
    @StateObject var viewModel: HotKeywordsViewViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                if viewModel.isLoading {
                    ProgressView {
                        Text("Loading...")
                    }
                } else {
                    listView()
                    Spacer()
                }
            }
            .navigationTitle("Từ khóa hot")
            .onAppear {
                viewModel.getKeywordList()
            }
            .alert("Error Occurred!", isPresented: $viewModel.isShowingError) {
                Button("Okay") {
                    viewModel.isShowingError = false
                    viewModel.errorMessage = ""
                }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    // MARK: - Views
    
    func listView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.keywordList.indices, id: \.self) { index in
                    cardView(currentIndex: index)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 200)
    }
    
    func cardView(currentIndex: Int) -> some View {
        let imageUrl = viewModel.keywordList[currentIndex].icon
        let title = viewModel.keywordList[currentIndex].name
        let totalColor = TitleBgColor.allCases.count
        return VStack {
            WebImage(url: URL(string: imageUrl)) { image in
                image.image?.resizable()
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: imageWidth, height: imageWidth)
            
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: calculateSuitableWidth(for: title, maxWidth: imageWidth), height: calculate2LineHeight())
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical, titlePadding)
                .background(TitleBgColor.allCases[currentIndex % totalColor].color)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    // MARK: - Calculations
    
    func calculateSuitableWidth(for text: String, font: UIFont = .systemFont(ofSize: 14, weight: .medium), maxWidth: CGFloat) -> CGFloat {
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        
        let textWidthSize = attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                                     height: .greatestFiniteMagnitude),
                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                        context: nil).size.width
        // just for line calculation
        let widthSizeWithPadding = textWidthSize + titlePadding * 2
        
        let numberOfLines = widthSizeWithPadding > imageWidth ? 2 : 1
        
        return max(maxWidth, (textWidthSize / CGFloat(numberOfLines)) + titlePadding * 2).rounded(.up)
    }
    
    
    func calculate2LineHeight(for font: UIFont = .systemFont(ofSize: 14, weight: .medium)) -> CGFloat {
        let attributedText = NSMutableAttributedString(string: "Hello\nHello", attributes: [NSAttributedString.Key.font: font])
        
        return  attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                         height: .greatestFiniteMagnitude),
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil).size.height
    }
    
}

#Preview {
    HotKeywordView(viewModel: HotKeywordsViewViewModel())
}
