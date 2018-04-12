//
//  ViewController.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import UIKit

class ToolBoxVC: UIViewController {

    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ToolBoxViewModel()
    static var cellId = "\(String(describing: ToolBoxCell.self))"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "My Tool Box"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = viewModel.isTableViewHidden
        emptyStateView.isHidden = !viewModel.isTableViewHidden
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func unwindToToolBoxVC(segue:UIStoryboardSegue) {}
}

// MARK: - Setup
extension ToolBoxVC {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let toolsSelectVC = segue.destination as? ToolsSelectVC else { return }
        toolsSelectVC.viewModel.didSelectToolsAction = { [weak self] selectedTools in
            self?.viewModel.add(tools: toolsSelectVC.viewModel.getSelectedTools())
            self?.tableView.reloadData()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Data Source / Delegate
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as? ToolBoxCell
            cell?.activityIndicator.isHidden = false
            cell?.activityIndicator.startAnimating()
            AppData.shared.delay { [weak self] in
                self?.viewModel.removeItem(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

// MARK: - Cell
class ToolBoxCell: UITableViewCell {
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var toolLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupCell(with model: ToolModel) {
        toolLabel.text = model.title
        toolImageView.image = UIImage(named: model.imageName)
        activityIndicator.isHidden = true
    }
}

// MARK: - Model
struct ToolBoxViewModel {
    private var boxTools: [ToolModel] = []
    
    var numberOfRows: Int {
        return boxTools.count
    }
    
    var isTableViewHidden: Bool {
        return numberOfRows == 0
    }
    
    func getToolCellModel(forIndex index: Int) -> ToolModel {
        return boxTools[index]
    }
    
    mutating func removeItem(at index: Int) {
        boxTools.remove(at: index)
    }
    
    mutating func add(tools: [ToolModel]) {
        boxTools.append(contentsOf: tools)
    }
}
