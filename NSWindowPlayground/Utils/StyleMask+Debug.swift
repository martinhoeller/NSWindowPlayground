//
//  StyleMask+Debug.swift
//  NSWindowPlayground
//
//  Created by Martin Höller on 26.09.2025.
//

import AppKit

extension NSWindow.StyleMask {
    func debugDescription() -> String {
        var options: [String] = []
        if contains(.titled) { options.append(".titled") }
        if contains(.closable) { options.append(".closable") }
        if contains(.miniaturizable) { options.append(".miniaturizable") }
        if contains(.resizable) { options.append(".resizable") }
        if contains(.texturedBackground) { options.append(".texturedBackground") }
        if contains(.unifiedTitleAndToolbar) { options.append(".unifiedTitleAndToolbar") }
        if contains(.fullScreen) { options.append(".fullScreen") }
        if contains(.fullSizeContentView) { options.append(".fullSizeContentView") }
        if contains(.borderless) { options.append(".borderless") }
        return options.joined(separator: ", ")
    }
}
