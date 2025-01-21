import SwiftUI

struct SpreadsheetView<ColumnView: View, RowView: View, ContentView: View, Column: Hashable, Row: Hashable>: View {
    init(
        columns: [Column],
        rows: [Row],
        columnWidth: CGFloat,
        columnHeight: CGFloat,
        rowWidth: CGFloat,
        rowHeight: CGFloat,
        columnView: @escaping (Column) -> ColumnView,
        rowView: @escaping (Row) -> RowView,
        contentView: @escaping (Column, Row) -> ContentView
    ) {
        self.columns = columns
        self.rows = rows
        self.columnWidth = columnWidth
        self.columnHeight = columnHeight
        self.rowWidth = rowWidth
        self.rowHeight = rowHeight
        self.columnCount = columns.count
        self.rowCount = rows.count
        self.columnRange = 0..<columnCount
        self.rowRange = 0..<rowCount
        self.columnView = columnView
        self.rowView = rowView
        self.contentView = contentView
    }

    @State var scrollOffset: CGPoint = .zero

    let columns: [Column]
    let rows: [Row]
    let columnWidth: CGFloat
    let columnHeight: CGFloat
    let rowWidth: CGFloat
    let rowHeight: CGFloat
    let columnCount: Int
    let rowCount: Int

    private let columnRange: Range<Int>
    private let rowRange: Range<Int>

    @ViewBuilder let columnView: (Column) -> ColumnView
    @ViewBuilder let rowView: (Row) -> RowView
    @ViewBuilder let contentView: (Column, Row) -> ContentView

    var contentSize: CGSize {
        .init(
            width: (columnWidth * CGFloat(columnCount)) + rowWidth,
            height: (rowHeight * CGFloat(rowCount)) + columnHeight
        )
    }

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                leftContentView()
                rightContentView()
            }
            ObservableScrollView(
                axis: [.vertical, .horizontal],
                scrollOffset: $scrollOffset
            ) { proxy in
                Color.clear
                    .frame(
                        width: contentSize.width,
                        height: contentSize.height
                    )
            }
            .opacity(0.5)
        }
    }

    func leftContentView() -> some View {
        VStack(spacing: 0) {
            Color.white
                .frame(
                    width: rowWidth,
                    height: columnHeight
                )
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(rows, id: \.self) { row in
                        rowView(row)
                            .frame(
                                width: rowWidth,
                                height: rowHeight
                            )
                    }
                }
                .offset(y: scrollOffset.y)
            }
            .disabled(true)
        }
    }

    func rightContentView() -> some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(columns, id: \.self) { column in
                        columnView(column)
                            .frame(
                                width: columnWidth,
                                height: columnHeight
                            )
                    }
                }
                .offset(x: scrollOffset.x)
            }
            .disabled(true)
            ScrollView([.vertical, .horizontal]) {
                VStack(spacing: 0) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(columns, id: \.self) { column in
                                contentView(column, row)
                                    .frame(
                                        width: columnWidth,
                                        height: rowHeight
                                    )
                            }
                        }
                    }
                }
                .offset(
                    x: scrollOffset.x,
                    y: scrollOffset.y
                )
            }
        }
    }
}

private extension CGPoint {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value += nextValue()
    }
}

private struct ObservableScrollView<Content: View>: View {
    let axis: Axis.Set
    @Binding var scrollOffset: CGPoint
    let content: (ScrollViewProxy) -> Content
    @Namespace var scrollSpace

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(axis) {
                content(proxy)
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollViewOffsetPreferenceKey.self,
                                value: geo.frame(in: .named(scrollSpace)).origin
                            )
                    })
            }
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }
}

struct SpreadsheetView_Previews: PreviewProvider {
    static var columns = (0..<10)
        .map { i in
            "C \(i)"
        }

    static var rows = (0..<10)
        .map { i in
            "R \(i)"
        }

    static var previews: some View {
        SpreadsheetView(
            columns: columns,
            rows: rows,
            columnWidth: 100,
            columnHeight: 50,
            rowWidth: 100,
            rowHeight: 50
        ) { column in
            Text(column)
        } rowView: { row in
            Text(row)
        } contentView: { column, row in
            Text("\(column) \(row)")
        }
    }
}
