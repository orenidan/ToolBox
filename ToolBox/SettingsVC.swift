//
//  SettingsVC.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import UIKit
import M13Checkbox

class SettingsVC: UITableViewController {

    var viewModel = SettingsViewModel()
    static var cellId = "\(String(describing: SettingsCell.self))"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: IndexPath(row: viewModel.indexForSelectedRow, section: 0),
                            animated: false,
                            scrollPosition: .none)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsVC.cellId,
                                                 for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setup(with: viewModel.settingsCellModel(at: indexPath.row))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell(at: indexPath.row)
    }
}

class SettingsCell: UITableViewCell {
    @IBOutlet weak var checkbox: M13Checkbox! {
        didSet {
            checkbox.setMarkType(markType: .radio, animated: false)
            checkbox.boxType = .circle
            checkbox.stateChangeAnimation = .bounce(.stroke)
        }
    }
    @IBOutlet weak var title: UILabel!    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        checkbox.setCheckState(selected ? .checked : .unchecked, animated: true)
    }
    
    func setup(with model: SettingsCellModel) {
        title.text = model.title
        checkbox.setCheckState(model.isSelected ? .checked : .unchecked, animated: false)
    }
}

struct SettingsViewModel {
    var simulationCells: [SettingsCellModel] = [.none, .network, .badNetwork, .noNetwork, .offline].map {
        SettingsCellModel(simulationState: $0, isSelected: AppData.shared.appSimulationState == $0)
    }
    var numberOfRows: Int {
        return simulationCells.count
    }
    func selectedCell(at index: Int) {
        AppData.shared.appSimulationState = simulationCells[index].simulationState
    }
    func settingsCellModel(at index: Int) -> SettingsCellModel {
        return simulationCells[index]
    }
    var indexForSelectedRow: Int {
        return simulationCells.index { $0.simulationState == AppData.shared.appSimulationState } ?? 0
    }
}

struct SettingsCellModel {
    let simulationState: AppSimulationState
    let isSelected: Bool
    
    var title: String {
        return simulationState.title
    }
}

