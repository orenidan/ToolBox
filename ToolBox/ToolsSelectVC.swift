//
//  ToolsSelectVC.swift
//  ToolBox
//
//  Created by Oren Idan on 17/03/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import UIKit
import M13Checkbox
import Blueprints

class ToolsSelectVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!

    static var cellId = "\(String(describing: ToolsSelectCell.self))"
    var viewModel = ToolsSelectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    @IBAction func saveTools(_ sender: Any) {
        guard AppData.shared.isNetworkAvailable(presenter: self) else { return }
        if viewModel.shouldShowLoadingView {
            loadingView.alpha = 0
            loadingView.isHidden = false
            UIView.animate(withDuration: 0.5) { self.loadingView.alpha = 1 }
        }
        viewModel.saveTools()
    }
}

// MARK: - setup
extension ToolsSelectVC {
    private func setupCollectionView() {
        let blueprint = VerticalBlueprintLayout(
            itemsPerRow: 3,
            itemSize: CGSize(width: 100, height: 100),
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        collectionView.setCollectionViewLayout(blueprint, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
}

// MARK: - Data Source / Delegate
extension ToolsSelectVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolsSelectVC.cellId,
                                                            for: indexPath) as? ToolsSelectCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(with: viewModel.getToolModel(forIndex: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeSelectedCell(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeSelectedCell(at: indexPath)
    }
    
    func changeSelectedCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ToolsSelectCell else { return }
        viewModel.setTool(at: indexPath.row, isSelected: cell.isSelected)
    }
}

// MARK: - Cell
class ToolsSelectCell: UICollectionViewCell {
    @IBOutlet weak var toolsImageView: UIImageView!
    @IBOutlet weak var checkbox: M13Checkbox! {
        didSet {
            checkbox.isEnabled = false
            checkbox.setMarkType(markType: .checkmark, animated: false)
            checkbox.boxType = .square
            checkbox.stateChangeAnimation = .fill
            checkbox.markType = .checkmark
            checkbox.cornerRadius = 2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkbox.setCheckState(.unchecked, animated: false)
    }
    
    override var isSelected: Bool {
        didSet {
            checkbox.setCheckState(isSelected ? .checked : .unchecked, animated: false)
        }
    }
    
    func setupCell(with model: ToolModel) {
        toolsImageView.image = UIImage(named: model.imageName)
    }
}

// MARK: - Model
struct ToolsSelectViewModel {
    private var allTools: [ToolModel] = []
    private var selectedTools: Set<ToolModel> = []
    var didSelectToolsAction: ([ToolModel]) -> Void = { _ in }
    
    init() {
        allTools = AppData.getAllTools()
    }
    
    var numberOfRows: Int {
        return allTools.count
    }
    
    func getToolModel(forIndex index: Int) -> ToolModel {
        return allTools[index]
    }
    
    mutating func setTool(at index: Int, isSelected: Bool) {
        let tool = getToolModel(forIndex: index)
        if isSelected {
            selectedTools.insert(tool)
        } else {
            selectedTools.remove(tool)
        }
    }
    
    func getSelectedTools() -> [ToolModel] {
        return Array(selectedTools)
    }
    
    func saveTools() {
        AppData.shared.delay {
            self.didSelectToolsAction(self.getSelectedTools())
        }
    }
    
    var shouldShowLoadingView: Bool {
        return AppData.shared.appSimulationState != .none
    }
}
