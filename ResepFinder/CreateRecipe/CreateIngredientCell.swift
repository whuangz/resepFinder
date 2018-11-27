//
//  IngredientCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

protocol GetCellHeight {
    func insertedCellHeight(cell: RFBaseTableCell)
}

class CreateIngredientCell: RFBaseTableCell {
    
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
    fileprivate var servingTxt: UITextField!
    fileprivate var headerBtn: RFPrimaryBtn!
    fileprivate var ingredientTableView: TPKeyboardAvoidingTableView!
    
    private var numberOfIngredient: [Int] = [0,1]
    var delegate: GetCellHeight?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        registerCell()
        addAction()
    }
    
    private func registerCell(){
        self.ingredientTableView.register(AddIngredientCell.self, forCellReuseIdentifier: "addIngredientCell")
    }
    
    private func addAction(){
        headerBtn.rx.tap.subscribe(onNext: {
            self.ingredientTableView.beginUpdates()
            
            let indexCount = self.numberOfIngredient.count
            self.numberOfIngredient.append(indexCount + 1)
            let indexTobeAdded = IndexPath(row: indexCount, section: 0)
            self.ingredientTableView.insertRows(at: [indexTobeAdded] , with: .automatic)
            
            self.ingredientTableView.endUpdates()
            
            self.ingredientTableView.selectRow(at: indexTobeAdded, animated: true, scrollPosition: .bottom)
            self.delegate?.insertedCellHeight(cell: self)
            let cell = self.ingredientTableView.cellForRow(at: indexTobeAdded) as! AddIngredientCell
            cell.ingredientField.becomeFirstResponder()
        }).disposed(by: self.dispose)
        
        
    }
    
}

extension CreateIngredientCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfIngredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addIngredientCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        endEditing(true)
    }
    
}

//MARK: - Initialize & Prepare UI
extension CreateIngredientCell {
    
    fileprivate func prepareUI(){
        self.ingredientTableView = getTableView()
        self.headerLbl = getSubheader()
        self.servingTxt = getTextField()
        self.headerBtn = getBtn()
        self.ingredientTableView.tableFooterView = footer
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
    }
    
    fileprivate func layoutViews(){
        
        addSubview(ingredientTableView)
        headerView.addSubview(headerLbl)
        headerView.addSubview(servingTxt)
        footer.addSubview(headerBtn)
        
        _ = self.ingredientTableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16)
        _ = self.headerLbl.anchor(top: self.headerView.topAnchor, left: self.headerView.leftAnchor, topConstant: 16, leftConstant: 16)
        _ = self.servingTxt.anchor(left: self.headerLbl.rightAnchor, right: self.headerView.rightAnchor, leftConstant: 8, rightConstant: 16)
        _ = self.servingTxt.centerConstraintWith(centerY: self.headerLbl.centerYAnchor)
            self.servingTxt.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        //_ = self.headerBtn.anchor(left: self.headerLbl.rightAnchor, right: self.headerView.rightAnchor, leftConstant: 8, rightConstant: 0, widthConstant: 60)
        //_ = self.headerBtn.centerConstraintWith(centerY: self.headerLbl.centerYAnchor)
        
        _ = self.headerBtn.anchor(left: footer.leftAnchor, right: footer.rightAnchor, leftConstant: 32, rightConstant: 32, heightConstant: 30)
        _ = self.headerBtn.centerConstraintWith(centerX: self.footer.centerXAnchor, centerY: self.footer.centerYAnchor)
    }
    
    private func getTableView() -> TPKeyboardAvoidingTableView {
        let tableView = TPKeyboardAvoidingTableView()
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
        label.text = "Ingredients"
        return label
    }
    
    fileprivate func getTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "2 (people)"
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.font = RFFont.instance.bodyMedium12
        
        return textField
    }
    
    fileprivate func getView() -> UIView{
        let view = UIView()
        return view
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn{
        let button = RFPrimaryBtn()
        
        button.setTitle("Add Ingredient", for: .normal)
        button.backgroundColor = RFColor.instance.darkGreen1
        button.setCornerWith(radius: 15)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
        return button
    }
    
}

