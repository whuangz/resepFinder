//
//  CreateStepsCell.swift
//  ResepFinder
//
//  Created by William Huang on 27/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class CreateStepsCell: RFBaseTableCell {
    
    fileprivate let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let footer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: RFScreenHelper.screenWidth(), height: 50))
        view.backgroundColor = .white
        return view
    }()
    fileprivate var headerLbl: UILabel!
    fileprivate var timeTxt: UITextField!
    fileprivate var headerBtn: RFPrimaryBtn!
    fileprivate var stepsTableView: UITableView!
    
    private var numberOfSteps: [Int] = [1,2]
    var delegate: GetCellHeight?
    var viewModel: CreateStepVM?
    var parent: CreateVC?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        registerCell()
        addAction()
    }
    
    private func registerCell(){
        self.stepsTableView.register(AddStepsCell.self, forCellReuseIdentifier: "addStepCell")
    }
    
    private func addAction(){
        headerBtn.rx.tap.subscribe(onNext: {
            self.stepsTableView.beginUpdates()
            
            let indexCount = self.numberOfSteps.count
            self.numberOfSteps.append(indexCount + 1)
            let indexTobeAdded = IndexPath(row: indexCount, section: 0)
            self.stepsTableView.insertRows(at: [indexTobeAdded] , with: .automatic)
            
            self.stepsTableView.endUpdates()
            self.stepsTableView.selectRow(at: indexTobeAdded, animated: true, scrollPosition: .none)
            self.delegate?.insertedCellHeight(cell: self)
            let cell = self.stepsTableView.cellForRow(at: indexTobeAdded) as! AddStepsCell
            cell.stepDescription.becomeFirstResponder()
        }).disposed(by: self.dispose)
        
    }
    
    func setupViewModel(vm: CreateStepVM){
        self.viewModel = vm
        observeViewModel(vm: self.viewModel!)
    }
    
    func observeViewModel(vm: CreateStepVM){
        self.timeTxt.rx.text.orEmpty.bind(to: vm.timeTxt).disposed(by: self.dispose)
    }
    
}



extension CreateStepsCell: ParentVCProtocol {
    func parentController() -> UIViewController {
        return self.parent!
    }
}

extension CreateStepsCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addStepCell") as! AddStepsCell
        cell.stepNo.setTitle("\(numberOfSteps[indexPath.item])")
        cell.cellAtIndex = indexPath.item
        cell.delegate = self
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        endEditing(true)
    }
    
}

extension CreateStepsCell: AddStepProtocol {
    func didChooseImage(data: [Int : String]) {
        if let key = data.keys.first, let val = data.values.first {
            self.viewModel?.stepsImg![key] = val
        }
    }
    
    func setDetailsView(data: [Int : String]) {
        if let key = data.keys.first, let val = data.values.first {
            self.viewModel?.stepsTxt![key] = val
        }
    }
}


//MARK: - Initialize & Prepare UI
extension CreateStepsCell {
    
    
    fileprivate func prepareUI(){
        self.stepsTableView = getTableView()
        self.headerLbl = getSubheader()
        self.timeTxt = getTextField()
        self.headerBtn = getBtn()
        self.stepsTableView.tableFooterView = footer

        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
    }
    
    fileprivate func layoutViews(){
        
        addSubview(stepsTableView)
        headerView.addSubview(headerLbl)
        headerView.addSubview(timeTxt)
        footer.addSubview(headerBtn)
        
        _ = self.stepsTableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16)
        _ = self.headerLbl.anchor(top: self.headerView.topAnchor, left: self.headerView.leftAnchor, topConstant: 16, leftConstant: 16)
        _ = self.timeTxt.anchor(left: self.headerLbl.rightAnchor, right: self.headerView.rightAnchor, leftConstant: 8, rightConstant: 16)
        _ = self.timeTxt.centerConstraintWith(centerY: self.headerLbl.centerYAnchor)
        self.timeTxt.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        //_ = self.headerBtn.anchor(left: self.headerLbl.rightAnchor, right: self.headerView.rightAnchor, leftConstant: 8, rightConstant: 0, widthConstant: 60)
        //_ = self.headerBtn.centerConstraintWith(centerY: self.headerLbl.centerYAnchor)
        
        _ = self.headerBtn.anchor(left: footer.leftAnchor, right: footer.rightAnchor, leftConstant: 32, rightConstant: 32, heightConstant: 30)
        _ = self.headerBtn.centerConstraintWith(centerX: self.footer.centerXAnchor, centerY: self.footer.centerYAnchor)
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        return tableView
    }
    
    fileprivate func getSubheader() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = RFFont.instance.subHead16
        label.text = "Steps"
        return label
    }
    
    fileprivate func getTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Time (30 mins)"
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.font = RFFont.instance.bodyMedium12
        textField.autocorrectionType = .no
        return textField
    }
    
    fileprivate func getView() -> UIView{
        let view = UIView()
        return view
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn{
        let button = RFPrimaryBtn()
        
        button.setTitle("Add Step", for: .normal)
        button.backgroundColor = RFColor.instance.darkGreen1
        button.setCornerWith(radius: 15)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
        return button
    }
    
}


