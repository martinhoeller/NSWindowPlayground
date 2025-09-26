//
//  WindowAccessor.swift
//  NSWindowPlayground
//
//  Created by Martin Höller on 26.09.2025.
//

import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void
    func makeNSView(context: Context) -> NSView {
        let v = NSView()
        DispatchQueue.main.async { callback(v.window) }   // when window attaches
        return v
    }
    func updateNSView(_ v: NSView, context: Context) {
        DispatchQueue.main.async { callback(v.window) }
    }
}
