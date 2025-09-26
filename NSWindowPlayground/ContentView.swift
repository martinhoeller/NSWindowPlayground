//
//  ContentView.swift
//  NSWindowPlayground
//
//  Created by Martin Höller on 26.09.2025.
//

import SwiftUI
import AppKit

class DemoWindow: NSWindow {
    override var canBecomeKey: Bool { true }
}

struct ContentView: View {
    @State var window: NSWindow?
    @State var demoWindow = DemoWindow()

    @State var styleMask: NSWindow.StyleMask = [.titled, .closable, .resizable, .miniaturizable]
    @State var titleVisibility: NSWindow.TitleVisibility = .visible
    @State var titlebarAppearsTransparent = false
    @State var toolbarStyle: NSWindow.ToolbarStyle = .automatic
    @State var titlebarSeparatorStyle: NSTitlebarSeparatorStyle = .automatic
    @State var fullSizeContentView = false
    @State var hasShadow = true
    @State var alphaValue: CGFloat = 1
    @State var backgroundColor: Color = Color(nsColor: .windowBackgroundColor)

    var body: some View {
        TabView {
            windowPropertiesForm
                .tabItem { Text("Window Properties") }

            styleMaskForm
                .tabItem { Text("Style Mask") }

            about
                .tabItem { Text("About") }
        }
        .tabViewStyle(.grouped)
        .padding()
        .background {
            WindowAccessor {
                window = $0
                $0?.title = "NSWindow Playground"
            }
        }
        .frame(width: 500)
        .task {
            demoWindow.contentView = NSHostingView(rootView: DemoContentView())
            updateStyleMask()
        }
        .onAppear {
            // Position the windows on screen in a way that makes sense.
            // The delay is necessary because the windows are not immediately layed out correctly.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                guard let window else { return }

                window.center()

                demoWindow.makeKeyAndOrderFront(nil)
                demoWindow.center()
                var demoFrame = demoWindow.frame
                demoFrame.origin.x = window.frame.origin.x - demoFrame.width - 20
                demoWindow.setFrame(demoFrame, display: false)
            }
        }
        .onChange(of: fullSizeContentView) {
            if fullSizeContentView {
                styleMask.insert(.fullSizeContentView)
            } else {
                styleMask.remove(.fullSizeContentView)
            }
        }
        .onChange(of: styleMask) {
            updateStyleMask()
        }
        .onChange(of: titleVisibility) {
            demoWindow.titleVisibility = titleVisibility
        }
        .onChange(of: titlebarAppearsTransparent) {
            demoWindow.titlebarAppearsTransparent = titlebarAppearsTransparent
        }
        .onChange(of: toolbarStyle) {
            demoWindow.toolbarStyle = toolbarStyle
        }
        .onChange(of: titlebarSeparatorStyle) {
            demoWindow.titlebarSeparatorStyle = titlebarSeparatorStyle
        }
        .onChange(of: alphaValue) {
            demoWindow.alphaValue = alphaValue
        }
        .onChange(of: backgroundColor) {
            if let cgColor = backgroundColor.cgColor {
                demoWindow.backgroundColor = NSColor(cgColor: cgColor)
            }
        }
        .onChange(of: hasShadow) {
            demoWindow.hasShadow = hasShadow
        }
    }

    private var windowPropertiesForm: some View {
        Form {
            Toggle("Full size content view", isOn: $fullSizeContentView)

            Toggle("titlebarAppearsTransparent", isOn: $titlebarAppearsTransparent)

            Toggle("hasShadow", isOn: $hasShadow)
                .padding(.bottom)

            Picker("titleVisibility", selection: $titleVisibility) {
                Text("visible").tag(NSWindow.TitleVisibility.visible)
                Text("hidden").tag(NSWindow.TitleVisibility.hidden)
            }
            .pickerStyle(.radioGroup)
            .padding(.bottom)

            Picker("toolbarStyle", selection: $toolbarStyle) {
                Text("automatic").tag(NSWindow.ToolbarStyle.automatic)
                Text("expanded").tag(NSWindow.ToolbarStyle.expanded)
                Text("preference").tag(NSWindow.ToolbarStyle.preference)
                Text("unified").tag(NSWindow.ToolbarStyle.unified)
                Text("unifiedCompact").tag(NSWindow.ToolbarStyle.unifiedCompact)
            }
            .pickerStyle(.radioGroup)
            .padding(.bottom)

            Picker("titlebarSeparatorStyle", selection: $titlebarSeparatorStyle) {
                Text("automatic").tag(NSTitlebarSeparatorStyle.automatic)
                Text("none").tag(NSTitlebarSeparatorStyle.none)
                Text("line").tag(NSTitlebarSeparatorStyle.line)
                Text("shadow").tag(NSTitlebarSeparatorStyle.shadow)
            }
            .pickerStyle(.radioGroup)
            .padding(.bottom)

            Slider(
                value: $alphaValue,
                in: 0...1,
                label: { Text("Alpha Value")} ,
                minimumValueLabel: { Text("0") },
                maximumValueLabel: { Text("1") }
            )
            .frame(width: 300)

            LabeledContent("", value: "\(alphaValue.formatted())")
                .foregroundStyle(.secondary)

            ColorPicker("Background Color", selection: $backgroundColor)
        }
        .padding()
        .fixedSize()
    }

    private var styleMaskForm: some View {
        Form {
            Text("Changing the window style mask may lead to unexpected results.")
                .foregroundStyle(.orange)
                .padding(.bottom)

            Section {
                Toggle(isOn: binding(for: .texturedBackground)) {
                    Text("texturedBackground")
                    Text("deprecated").foregroundStyle(.red)
                }
                Toggle("fullSizeContentView", isOn: binding(for: .fullSizeContentView))
            }

            Section {
                Text("Traffic light buttons").font(.headline)
                    .padding(.top)
                Toggle("closable", isOn: binding(for: .closable))
                Toggle("miniaturizable", isOn: binding(for: .miniaturizable))
                Toggle("resizable", isOn: binding(for: .resizable))
            }
            Section {
                Text("Title").font(.headline)
                    .padding(.top)
                Toggle("titled", isOn: binding(for: .titled))
                Toggle("unifiedTitleAndToolbar", isOn: binding(for: .unifiedTitleAndToolbar))
            }

            Section {
                Text("Window Type").font(.headline)
                    .padding(.top)
                Toggle("utilityWindow", isOn: binding(for: .utilityWindow))
                Toggle("docModalWindow", isOn: binding(for: .docModalWindow))
                Toggle("nonactivatingPanel", isOn: binding(for: .nonactivatingPanel))
                Toggle("hudWindow", isOn: binding(for: .hudWindow))
            }
        }
        .padding()
        .fixedSize()
    }

    private var about: some View {
        VStack {
            Text("made by")
                .foregroundStyle(.secondary)
            Text("Martin Höller")
                .font(.title)

            Link("Check out my Apps", destination: URL(string: "https://bluebanana-software.com")!)
            Link("@martinhoeller on Mastodon", destination: URL(string: "https://mastodon.social/@martinhoeller")!)
        }
    }

    private func binding(for option: NSWindow.StyleMask) -> Binding<Bool> {
        Binding<Bool>(
            get: { styleMask.contains(option) },
            set: { isOn in
                if isOn {
                    styleMask.insert(option)
                } else {
                    styleMask.remove(option)
                }
            }
        )
    }

    private func updateStyleMask() {
        demoWindow.styleMask = styleMask
    }
}

#Preview {
    ContentView()
}
