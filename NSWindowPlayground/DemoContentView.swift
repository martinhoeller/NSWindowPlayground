//
//  DemoContentView.swift
//  NSWindowPlayground
//
//  Created by Martin Höller on 26.09.2025.
//

import SwiftUI
import AppKit

struct DemoContentView: View {
    @State var showsBackgroundImage = true
    @State var showsToolbar = false
    @State var title: String = "Window"
    @State var subtitle: String = ""
    @State private var window: NSWindow?

    var body: some View {
        ZStack {
            if showsBackgroundImage {
                Image(.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }

            Form {
                TextField("Title", text: $title)
                TextField("Subtitle", text: $subtitle)
                Toggle("Show background image", isOn: $showsBackgroundImage)
                Toggle("Show toolbar", isOn: $showsToolbar)
            }
            .frame(maxWidth: 300)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(8)
        }
        .frame(minWidth: 400, maxWidth: 1600, minHeight: 300, maxHeight: 1200)
        .toolbar {
            if showsToolbar {
                ToolbarItem {
                    Button("Item 1", systemImage: "gearshape") {}
                }
                ToolbarItem {
                    Button("Item 2", systemImage: "hammer") {}
                }
            }
        }
        .background {
            WindowAccessor {
                window = $0
                $0?.title = title
            }
        }
        .onAppear { window?.title = title }
        .onChange(of: title) { window?.title = title }
        .onChange(of: subtitle) { window?.subtitle = subtitle }
    }
}
