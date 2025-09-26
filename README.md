# NSWindow Playground

This is a small utility app to test out various NSWindow style settings.

## What does it do?

![Screenshot](/Screenshots/nswindowplayground.png)

- Play around with various `NSWindow` settings
- Change the window’s style mask

All changes are applied live in a demo window.

## Known issues

Changing the style mask sometimes breaks the window style.
Some settings won’t have any effect, e.g. because they only apply to `NSPanel`s and not regular `NSWindow`s.

