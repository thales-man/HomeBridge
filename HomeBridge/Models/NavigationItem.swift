//  NavigationItem.swift
//  HomeBridge
//
//  Created by colin on 06/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import SwiftUI

final class NavigationItem: ObservableObject {
    @Published var device: ManageableDevice = ManageableDevice()
    @Published var actionSheet: AnyView = NavigationItem.emptyView()

    @Published var showingActionSheet: Bool = false

    // ib menu action 'preferences' in app delegate linked to this
    func showPreferences() {
        actionSheet = AnyView(SystemConfigurationView(selected: self, config: configProvider))
        showingActionSheet = true
    }

    // ib menu action 'console' in app delegate linked to this
    func showConsole() {
        actionSheet = AnyView(ConsoleTextView(selected: self))
        showingActionSheet = true
    }

    // invoked from the estate manager, when the bridge state is 'unpaired'
    func showQRCode(_ qrCode: String) {
        actionSheet = AnyView(QRCodeView(selected: self, qrCode: qrCode))
        showingActionSheet = true
    }

    func hideActionSheet() {
        showingActionSheet = false
    }

    private static func emptyView() -> AnyView {
        return AnyView(Text("this view has not been intitialised..."))
    }
}
