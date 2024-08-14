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
    let title = "Sách Combo 2 Cuốn : Tư Duy Ngược + Tư Duy Mở (Nguyễn Anh Dũng) - SBOOKS"
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 16) {
                        ForEach(1..<10, id: \.self) { value in
                            cardView
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 200)
                Spacer()
            }
            .navigationTitle("Từ khóa hot")
        }
    }
    
    // MARK: - Views
    
    var cardView: some View {
        VStack {
            WebImage(url: URL(string: "https://salt.tikicdn.com/cache/750x750/ts/product/65/c2/29/b5f8f3fe5e04758a05cf00cea66b4aa8.png")) { image in
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
                .frame(width: calculateSuitableWidth(for: title, maxWidth: imageWidth))
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical)
                .background(Color.red)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    // MARK: - Calculations
    
    func calculateSuitableWidth(for text: String, font: UIFont = .systemFont(ofSize: 14, weight: .medium), maxWidth: CGFloat) -> CGFloat {
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        
        let textWidthSize = attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
                                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                    context: nil).size.width
        // just for line calculation
        let widthSizeWithPadding = textWidthSize + titlePadding * 2
        
        let numberOfLines = widthSizeWithPadding > imageWidth ? 2 : 1
        
        return max(maxWidth, (textWidthSize / CGFloat(numberOfLines)) + titlePadding * 2).rounded(.up)
    }
    
}

#Preview {
    HotKeywordView()
}
