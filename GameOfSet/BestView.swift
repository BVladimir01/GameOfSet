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
    
//    init
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
//    body
    var body: some View {
        GeometryReader {geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count, size: geometry.size, atAspectRatio: aspectRatio)
//            Either AspectGrid
            if gridItemSize > 60 {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)],
                    spacing: 0) {
                        ForEach(items) {
                            item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
//                or ScrollView
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 0)],
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
