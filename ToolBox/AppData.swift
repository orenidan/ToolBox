//
//  AppData.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation

enum AppSimulationState {
    case none, network, badNetwork, offline
    
    var title: String {
        switch self {
        
        case .none:
            return "none"
        case .network:
            return "network"
        case .badNetwork:
            return "Bad Network"
        case .offline:
            return "Offline"
        }
    }
}

class AppData {
    static var shared = AppData()
    var appSimulationState = AppSimulationState.none
    
    private init() {}
    static func getAllTools() -> [ToolModel] {
        return (1...32).map { ToolModel(id: $0, imageName: AppData.toolImageName(for: $0)) }
    }
    
    static func toolImageName(for index: Int) -> String {
        return "tool_\(index)"
    }
}

struct ToolModel {
    let id: Int
    let imageName: String
    let title: String
    var isSelected: Bool
    
    init(id:Int, imageName: String, title: String = "test", isSelected: Bool = false) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.isSelected = isSelected
    }
}

extension ToolModel: Equatable, Hashable {
    static func ==(lhs: ToolModel, rhs: ToolModel) -> Bool {
        return lhs.id == rhs.id && lhs.imageName == rhs.imageName
    }
    
    var hashValue: Int {
        return id.hashValue << 15 + imageName.hashValue
    }
}
