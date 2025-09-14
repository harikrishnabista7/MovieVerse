//
//  MockNetworkMonitor.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//

import Combine
@testable import MovieVerse
import Network

// MARK: - Mock NetworkMonitor for Testing

final class MockNetworkMonitor: ConnectionMonitor {
    init() { }
    
    @Published private(set) var isConnected: Bool = false

    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }

    private(set) var connectionType: NWInterface.InterfaceType?

    // Test helper methods
    func simulateConnectionChange(isConnected: Bool) {
        self.isConnected = isConnected
    }

    func simulateConnectionType(_ type: NWInterface.InterfaceType?) {
        connectionType = type
    }
}
