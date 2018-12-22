//
//  CreateVC.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class CreateVC: RFBaseController {
    private var tableView: TPKeyboardAvoidingTableView!
    private var ingredientsHeight: CGFloat = 200
    private var stepsHeight: CGFloat = 400
    private var picker = UIImagePickerController()
    private var uploadCell: UploadCell?
    private var selectedPickerCell: RFBaseTableCell?
    private var viewModel: CreateVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
        setupViewModel()
        setupDelegate()
    }
    
    private func registerCell(){
        self.tableView.register(UploadCell.self, forCellReuseIdentifier: "uploadCell")
        self.tableView.register(RecipeDetailCell.self, forCellReuseIdentifier: "createRecipe")
        self.tableView.register(CreateIngredientCell.self, forCellReuseIdentifier: "createIngredientCell")
        self.tableView.register(CreateStepsCell.self, forCellReuseIdentifier: "createStepsCell")
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = true
        self.setupCustomLeftBarItem(image: "close", action: #selector(self.dismissToPreviousScreen))
        self.setupRightBarItemWith(title: "Done", action: #selector(submitData))
    }
    
    private func setupDelegate(){
        self.picker.delegate = self
    }
    
    @objc func submitData(){
        view.endEditing(true)
        guard let viewModel = self.viewModel else {return}

        if viewModel.sendData(){
            RFAlertHelper.instance.showSuccessAlert("Recipe's Successfully Created", tapCompletion: { (_) in
            })
            self.dismissToPreviousScreen()
        }
        
    }
    
    func setupViewModel(){
        self.viewModel = CreateVM()
    }

}


extension CreateVC {
    
    private func prepareUI(){
        self.tableView = getTableView()
        
        layoutViews()
    }
    
    private func layoutViews(){
        self.view.addSubview(tableView)
        _ = tableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
    
    private func getTableView() -> TPKeyboardAvoidingTableView {
        let tableView = TPKeyboardAvoidingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        
        return tableView
    }
    
}

extension CreateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = RFCreateRecipeSection(rawValue: indexPath.row)
        switch section! {
        case .upload:
            return createUploadCell()
        case .createRecipe:
            return createRecipeCell()
        case .ingredients:
            return createIngredientsCell()
        case .steps:
            return createStepsCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = RFCreateRecipeSection(rawValue: indexPath.row)
        switch section! {
        case .upload:
            return 180
        case .createRecipe:
            return 120
        case .ingredients:
            return ingredientsHeight
        case .steps:
            return stepsHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }

    private func createUploadCell() -> UITableViewCell{
        uploadCell = tableView.dequeueReusableCell(withIdentifier: "uploadCell") as? UploadCell
        uploadCell?.delegate = self
        return uploadCell!
    }
    
    private func createRecipeCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createRecipe") as! RecipeDetailCell
        cell.setupViewModel(vm: (self.viewModel?.recipeDetailVM)!)
        return cell
    }
    
    private func createIngredientsCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createIngredientCell") as! CreateIngredientCell
        cell.delegate = self
        cell.setupViewModel(vm: (self.viewModel?.createIngredientVM)!)
        return cell
    }
    
    private func createStepsCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createStepsCell") as! CreateStepsCell
        cell.delegate = self
        cell.parent = self
        cell.setupViewModel(vm: (self.viewModel?.createStepVM)!)
        return cell
    }
    
}

extension CreateVC: GetCellHeight {
    func insertedCellHeight(cell: RFBaseTableCell) {
        self.tableView.beginUpdates()
        if cell is CreateIngredientCell {
            self.ingredientsHeight += 45
        }else{
            self.stepsHeight += 145
        }
        self.tableView.endUpdates()
    }
    
}

extension CreateVC: UploadImageProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func didUploadImage(cell: RFBaseTableCell) {
        self.picker.allowsEditing = true
        self.picker.sourceType = .photoLibrary
        self.selectedPickerCell = cell
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if selectedPickerCell is UploadCell {
                self.uploadCell?.uploadView.image = image
                self.viewModel?.recipeImg = image
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
