//
//  ContentView.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 07/11/23.
//

import SwiftUI

struct ScoringSheet: View {
    @State var model: ScoringSheet.Model
    @State var rowHeight = 80.0
    @State var rowWidth = 80.0

    @State var scrollOffset: CGPoint = .zero
    @State private var scrollViewContentSize: CGSize = .zero
    @Namespace var scrollSpace
    
    @FocusState var focusState: UUID?
    var body: some View {
        ZStack {
            Image("MarsBack")
                .resizable(resizingMode: .stretch)
                .ignoresSafeArea()
            
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            
            GeometryReader {_ in
                VStack {
                    HStack(alignment: .top,spacing: 0) {
                        leftHeaders()
                        rightHeaders()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Button("+/-") {
                        model.sumOrMinus(currentFocus: focusState)
                    }
                    
                    Spacer()
                
                    Button("NEXT", systemImage: "arrow.forward.to.line") {
                        DispatchQueue.main.async {
                            withAnimation(.bouncy) {
                                focusState = model.getNextFocus(currentFocus: focusState)?.id
                            }
                        }
                    }.labelStyle(.titleAndIcon)
                }
            }
        }
    }
    private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
        static var defaultValue = CGPoint.zero
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            value += nextValue()
        }
    }
    
    
    
    func leftHeaders() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear
                .frame(
                    width: 100,
                    height: rowHeight
                )
                .opacity(0.1)
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach($model.categories, id: \.self) { category in
                        CategoryHeader(category: category)
                            .frame( width: 100,height: rowHeight
                            )}
                }
                .offset(y: scrollOffset.y)
            }
            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    func rightHeaders() -> some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach($model.players) { $player in
                        PlayerHeader(player: $player)
                            .frame(
                                width: rowWidth,
                                height: rowHeight
                            )
                        
                    }
                }
                .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 10))
                .offset(x: scrollOffset.x)
            }.disabled(true)
                .onTapGesture {
                    hideKeyboard()
                }
            
            ScrollViewReader { proxy in
                ScrollView([.horizontal, .vertical]) {
                    ZStack {
                        VStack(alignment: .leading, spacing: 0) {
                                ForEach ($model.categories) { category in
                                    CategoryView(category: category, focusState: _focusState, proxy: proxy, rowWidth: rowWidth, rowHeight: rowHeight)
                                }
                            }
                            .background(GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                                                Task { @MainActor in
                                                                    scrollViewContentSize = geo.size
                                                                }
                                                            }
                                    .preference(
                                        key: ScrollViewOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named(scrollSpace)).origin
                                    )
                        })
                    }
                }
                .onChange(of:focusState) {
                        withAnimation(.snappy(duration: 2)) {
                            proxy.scrollTo(focusState, anchor: .topLeading)
                        }
                    }.defaultScrollAnchor(.topLeading)
               
            }   .frame(
                maxWidth: scrollViewContentSize.width,
                maxHeight: scrollViewContentSize.height
            )
            .coordinateSpace(name: scrollSpace)
              .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
        }
        .frame(
         maxWidth: scrollViewContentSize.width     )
    }
    
    
}


extension ScoringSheet {
    struct PlayerHeader: View {
        @Binding var player: Player
        var body: some View {
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(Color(player.chosenColor.name()))
                    .frame(width: 30, height: 30)
                    .padding([.top, .leading, .trailing], 4)
                
                
                Text(player.name)
                    .font(.callout)
                    .lineLimit(1)
                    .bold()
                    .padding(4)
            }
        }
    }
}

extension ScoringSheet {
    struct CategoryView: View {
        @Binding var category: Category
        @FocusState var focusState: UUID?
        
        var proxy: ScrollViewProxy
        var rowWidth: CGFloat
        var rowHeight: CGFloat
        var body: some View {
            ZStack {
                Color(category.colorName)
                HStack (spacing: 0) {
                    ForEach ($category.playerScores) { $playerScore in
                        ZStack {
                            withAnimation(.easeIn(duration: 10)) {
                                if focusState == playerScore.id {
                                        Color(playerScore.player.chosenColor.name())
                                } else {
                                    Color.clear
                                }
                            }
                            TextField("",text: $playerScore.score, prompt: Text("-"))
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.automatic)
                                .keyboardType(.numberPad)
                                .tint(Color.white)
                                .focused($focusState, equals: playerScore.id)
                                .frame(width: rowWidth, height: rowHeight)
                                .background(focusState == playerScore.id ?           Color(playerScore.player.chosenColor.name()) : Color.clear)
                            .id(playerScore.id)
                            .animation(.default)
                        }
                            
                    }
                }
            }
        }
    }
}

extension ScoringSheet {
    struct CategoryHeader: View {
        @Binding var category: Category
        var body: some View {
            ZStack {
                Color(category.colorName)
                Text(category.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let players = [Player(name: "Player 1", chosenColor: .green),
                       Player(name: "Player 2", chosenColor: .yellow),
                       Player(name: "ABA ", chosenColor: .red),
                       Player(name: "New Player with new name which is really big ", chosenColor: .red),
                       Player(name: "Player 1", chosenColor: .green),
                                      Player(name: "Player 2", chosenColor: .yellow),
                                      Player(name: "ABA ", chosenColor: .red),
                       Player(name: "New Player with new name which is really big ", chosenColor: .black)]
        
        let categories = [Category(name: "Category 1", odd: true),
                          Category(name: "Two", odd: false),
                          Category(name: "Category 1", odd: true),
                                            Category(name: "Two", odd: false),
                          Category(name: "Category 1", odd: true),
                                            Category(name: "Two", odd: false),
                          Category(name: "Category 1", odd: true),
                                            Category(name: "Two", odd: false),
                          Category(name: "Category 1", odd: true),
                                            Category(name: "Two", odd: false),
                          Category(name: "Category 1", odd: true),
                                            Category(name: "Two", odd: false),]
        let model = ScoringSheet.Model(
            players: players, categories: categories)
        
        ScoringSheet(model: model)
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

extension View {
    func hideKeyboard () {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
