//  AppDelegate.swift
//  HomeBridge
//
//  Created by colin on 19/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var selected: NavigationItem!
    var window: NSWindow!

    @IBAction func preferences(_ sender: Any) {
        selected.showPreferences()
    }

    @IBAction func console(_ sender: Any) {
        selected.showConsole()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        selected = NavigationItem()
        let mainView = MainView()
            .environmentObject(selected)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: mainView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

