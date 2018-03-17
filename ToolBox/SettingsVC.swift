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

    let viewModel = SettingsViewModel()
    static var cellId = "\(String(describing: SettingsCell.self))"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.setup(with: viewModel.simulationCells[indexPath.row])

        return cell
    }
}

class SettingsCell: UITableViewCell {
    @IBOutlet weak var checkbox: M13Checkbox! {
        didSet {
            checkbox.setMarkType(markType: .radio, animated: false)
            checkbox.boxType = .circle
            checkbox.stateChangeAnimation = .bounce(.stroke)
            checkbox.markType = .radio
        }
    }
    @IBOutlet weak var title: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        checkbox.setCheckState(selected ? .checked : .unchecked, animated: true)
    }
    
    func setup(with model: AppSimulationState) {
        title.text = model.title
    }
}

struct SettingsViewModel {
    var simulationCells: [AppSimulationState] = [.none, .network, .badNetwork, .offline]
    var numberOfRows: Int {
        return simulationCells.count
    }
}

