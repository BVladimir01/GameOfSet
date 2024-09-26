//
//  AspectVGrid.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI


//struct that chooses best view for given number of items
struct BestView<Item: Identifiable, ItemView: View>: View  {
    
//    items to build view for
    var items: [Item]
//    aspect ratio for views
    var aspectRatio: CGFloat = 1
//    func that builds views from items
    var content: (Item) -> ItemView
    
    var maxItems: CGFloat
    var minItems: CGFloat
    
//    init
    init(_ items: [Item], aspectRatio: CGFloat, minItems: Int, maxItems: Int, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
        self.maxItems = CGFloat(maxItems)
        self.minItems = CGFloat(minItems)
    }
    
//    body
    var body: some View {
        GeometryReader {geometry in
            let givenWidth = geometry.size.width
            let gridItemSize = gridItemWidthThatFits(
                count: items.count, size: geometry.size, atAspectRatio: aspectRatio)
//            Either AspectGrid
            if gridItemSize > givenWidth / maxItems {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: min(gridItemSize, givenWidth / minItems)), spacing: 0)],
                    spacing: 0) {
                        ForEach(items) {
                            item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
//                or ScrollView
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: givenWidth / maxItems), spacing: 0)],
                    spacing: 0){
                        ForEach(items) {
                            item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
    
//    takes number of items, size (given space) and aspect ration
//    and returns width of itemView that will fit all items in size
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat) -> CGFloat {
            var columnCount = 1.0
            let count = CGFloat(count)
            repeat {
                let width = size.width / columnCount
                let height = width / aspectRatio
                let rowCount = (count / columnCount).rounded(.up)
                if rowCount * height < size.height {
                    return (size.width / columnCount).rounded(.down)
                }
                columnCount += 1
            } while columnCount < count
            return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
