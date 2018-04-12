//
//  AppData.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import UIKit

enum AppSimulationState {
    case none, network, badNetwork, noNetwork, offline
    
    var title: String {
        switch self {
        case .none:
            return "No Simulation"
        case .network:
            return "Simulate Network"
        case .badNetwork:
            return "Simulate Bad Network"
        case .noNetwork:
            return "Simulate No Network"
        case .offline:
            return "Simulate Offline?"
        }
    }
    
    var delayTime: Double {
        switch self {
        case .none:
            return 0
        case .network:
            return 3
        case .badNetwork:
            return 10
        case .noNetwork:
            return 200
        case .offline:
            return 0
        }
    }
}

class AppData {
    static var shared = AppData()
    var appSimulationState = AppSimulationState.none
    
    private init() {}
    static func getAllTools() -> [ToolModel] {
        return (1...32).map {
            ToolModel(id: $0, imageName: AppData.toolImageName(for: $0),
                      title:  AppData.toolName(for: $0 - 1))
        }
    }
    
    static func toolImageName(for index: Int) -> String {
        return "tool_\(index)"
    }
    
    static func toolName(for index: Int) -> String {
        guard index < toolNames.count else { return "test" }
        return toolNames[index]
    }
    
    static var toolNames = ["Helmet", "Axe", "Hammer", "drill", "Shovel",
                            "Screwdriver", "Shovel", "Jackhammer", "Paint Roller",
                            "Control", "Jackhammer", "Cement Mixer", "Cement Trowel",
                            "Pickaxe", "Chainsaw", "Cart", "Wrench", "Painter's Tape",
                            "Paint Can", "Sandpaper", "Jigsaw", "Ruler", "Motor Oil", "Vice",
                            "Saw", "Pliers", "Wrench", "Screwdriver", "Measuring tape", "Hammer",
                            "Drill", "Cement Trowel", "Cord"]
    
    func delay(operation: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + appSimulationState.delayTime) {
            operation()
        }
    }
    
    func isNetworkAvailable(presenter: UIViewController) -> Bool {
        guard appSimulationState == .noNetwork else { return true }
        let alertView = UIAlertController(title: "No internet connection",
                                          message: "Please check your connection and try again",
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Sorry :(",
                                     style: .default,
                                     handler: nil)
        alertView.addAction(okAction)
        presenter.present(alertView, animated: true)
        
        return false
    }
}

struct ToolModel {
    let id: Int
    let imageName: String
    let title: String
    var isSelected: Bool
    
    init(id:Int, imageName: String, title: String, isSelected: Bool = false) {
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
