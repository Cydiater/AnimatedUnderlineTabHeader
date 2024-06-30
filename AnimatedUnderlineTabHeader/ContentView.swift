//
//  ContentView.swift
//  AnimatedUnderlineTabHeader
//
//  Created by Cydiater on 30/6/2024.
//

import SwiftUI

struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

extension View {
    func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
            }
                .onPreferenceChange(SafeAreaInsetsKey.self) { value in
                    safeInsets.wrappedValue = value
                }
        )
    }
}

enum Page: String, Hashable { case Latest, Trending, Classic }

struct UnderlinedButton: View {
    private let page: Page
    
    @Binding var selectedPage: Page?
    
    var text: String { page.rawValue }
    let namespace: Namespace.ID
    
    init(_ page: Page, selectedPage: Binding<Page?>, namespace: Namespace.ID) {
        self.page = page
        self._selectedPage = selectedPage
        self.namespace = namespace
    }
    
    var selected: Bool { page == selectedPage }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedPage = page
            }
        }) {
            VStack {
                if !selected {
                    Text(text)
                        .fixedSize()
                        .foregroundColor(.secondary)
                } else {
                    Text(text)
                        .fixedSize()
                        .foregroundStyle(.tint)
                }
                
                if selected {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.tint)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: selected ? "underline" : page.rawValue, in: namespace, properties: .frame)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.clear)
                        .frame(height: 2)
                }

            }
            .padding(.top)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView: View {
    @Namespace var namespace
    @State private var safeAreaInsets: EdgeInsets = .init()
    @State private var selectedPage: Page? = Page.Latest
    
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ScrollView {
                            ForEach(0..<20, id: \.self) { idx in
                                HStack {
                                    Text(idx.description)
                                        .padding(.horizontal)
                                    Spacer()
                                    Text("1")
                                        .padding(.horizontal)
                                        .italic()
                                }
                                .font(.title)
                                .border(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                            }
                        }
                        .scrollTargetLayout()
                        .containerRelativeFrame(.horizontal)
                        .id(Page.Latest)
                        
                        ScrollView {
                            ForEach(0..<20, id: \.self) { idx in
                                HStack {
                                    Text(idx.description)
                                        .padding(.horizontal)
                                    Spacer()
                                    Text("2")
                                        .padding(.horizontal)
                                        .italic()
                                }
                                .font(.title)
                                .border(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                            }
                        }
                        .scrollTargetLayout()
                        .containerRelativeFrame(.horizontal)
                        .id(Page.Trending)
                        
                        ScrollView {
                            ForEach(0..<20, id: \.self) { idx in
                                HStack {
                                    Text(idx.description)
                                        .padding(.horizontal)
                                    Spacer()
                                    Text("3")
                                        .padding(.horizontal)
                                        .italic()
                                }
                                .font(.title)
                                .border(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                            }
                        }
                        .scrollTargetLayout()
                        .containerRelativeFrame(.horizontal)
                        .id(Page.Classic)
                    }
                    .safeAreaPadding(safeAreaInsets)
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $selectedPage)
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .getSafeAreaInsets($safeAreaInsets)
                .safeAreaInset(edge: .top) {
                    VStack(spacing: 0) {
                        HStack(spacing: 20) {
                            Spacer()
                            UnderlinedButton(.Latest, selectedPage: $selectedPage, namespace: namespace)
                            Spacer()
                            UnderlinedButton(.Trending, selectedPage: $selectedPage, namespace: namespace)
                            Spacer()
                            UnderlinedButton(.Classic, selectedPage: $selectedPage, namespace: namespace)
                            Spacer()
                        }
                        .font(.headline)
                        .padding(.horizontal)
                        .animation(.easeInOut, value: selectedPage)
                        Divider()
                    }
                    .background(.bar)
                }
                
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Attention")
                .tabItem {
                    Image(systemName: "star")
                    Text("Attention")
                }
            
            Text("Setting")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}

#Preview {
    ContentView()
}
