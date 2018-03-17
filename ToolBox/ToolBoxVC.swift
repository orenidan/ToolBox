//
//  ViewController.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import UIKit

class ToolBoxVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ToolBoxViewModel()
    static var cellId = "\(String(describing: ToolBoxCell.self))"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func unwindToToolBoxVC(segue:UIStoryboardSegue) {
        guard let toolsSelectVC = segue.source as? ToolsSelectVC else { fatalError() }
        viewModel.add(tools: toolsSelectVC.viewModel.getSelectedTools())
        tableView.reloadData()
    }
}

extension ToolBoxVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToolBoxVC.cellId,
                                                       for: indexPath) as? ToolBoxCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: viewModel.getToolCellModel(forIndex: indexPath.row))
        return cell
    }
}

class ToolBoxCell: UITableViewCell {
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var toolLabel: UILabel!
    
    func setupCell(with model: ToolModel) {
        toolLabel.text = model.title
        toolImageView.image = UIImage(named: model.imageName)
    }
}

struct ToolBoxViewModel {
    private var boxTools: [ToolModel] = []
    
    var numberOfRows: Int {
        return boxTools.count
    }
    
    func getToolCellModel(forIndex index: Int) -> ToolModel {
        return boxTools[index]
    }
    
    mutating func add(tools: [ToolModel]) {
        boxTools.append(contentsOf: tools)
    }
}
