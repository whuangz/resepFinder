//
//  AddStepsCell.swift
//  ResepFinder
//
//  Created by William Huang on 27/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import RxSwift
import RxGesture
import RxCocoa

protocol ParentVCProtocol {
    func parentController()  -> UIViewController
}

class AddStepsCell: RFBaseTableCell {
    
    var uploadImg: RFImageView!
    var stepNo: RFPrimaryBtn!
    var stepDescription: UITextField!
    var deleteBtn: RFPrimaryBtn!
    
    var cellAtIndex: Int?
    var delegate: AddStepProtocol?
    var parent: ParentVCProtocol?
    private var picker = UIImagePickerController()
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        observeData()
    }
    
    fileprivate func observeData(){
        //        guard let viewModel = self.viewModel else {return}
        
        self.stepDescription.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { (text) in
                self.delegate?.setDetailsView(data: [self.cellAtIndex! : self.stepDescription.text!])
            })
            .disposed(by: self.dispose)
        
        //
        
        self.picker.delegate = self
        self.uploadImg.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe { (_) in
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.getVC().present(self.picker, animated: true, completion: nil)
        }.disposed(by: self.dispose)
        
    }
    
    func getVC() -> UIViewController{
        return (self.parent?.parentController())!
    }
    
}

//MARK: - Initialize & Prepare UI
extension AddStepsCell {
    
    
    fileprivate func prepareUI(){
        self.uploadImg = getImageView()
        self.stepNo = getNoBtn()
        self.stepDescription = getTextField()
        self.deleteBtn = getBtn()
        self.deleteBtn.isHidden = true
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        
        addSubview(uploadImg)
        addSubview(stepNo)
        addSubview(stepDescription)
        addSubview(deleteBtn)
        
        _ = self.stepNo.anchor(top: topAnchor, left: leftAnchor, topConstant: 0, leftConstant: 16, widthConstant: 30)
            stepNo.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        _ = self.uploadImg.anchor(top: stepNo.topAnchor, left: stepNo.rightAnchor, leftConstant: 8, heightConstant: 100)
        _ = self.deleteBtn.anchor(left: self.uploadImg.rightAnchor, right: rightAnchor, rightConstant: 0, widthConstant: 60)
        _ = self.deleteBtn.centerConstraintWith(centerY: self.uploadImg.centerYAnchor)
        _ = self.stepDescription.anchor(top: uploadImg.bottomAnchor, left: uploadImg.leftAnchor, right: uploadImg.rightAnchor, topConstant: 8, heightConstant: 30)
        
        
    }
    
    fileprivate func getImageView() -> RFImageView {
        let imgView = RFImageView()
        imgView.setCornerWith(radius: 5)
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "uploadPhoto1")
        return imgView
    }
    
    fileprivate func getNoBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.titleLabel?.font = RFFont.instance.subHead16
        button.setBorderColor(UIColor.init(white: 0.9, alpha: 0.8), width: 1)
        button.setCornerWith(radius: 5)
        button.isUserInteractionEnabled = false
        return button
    }
    
    fileprivate func getTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Step Description"
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.addLineToBottomView(color: RFColor.instance.primGray, width: 0.5)
        textField.autocorrectionType = .no
        
        return textField
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn{
        let button = RFPrimaryBtn()
        
        button.setContentImageFor(active: "remove", inactive: "remove")
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        return button
    }
    
}

protocol AddStepProtocol {
    func setDetailsView(data: [Int:String])
    func didChooseImage(data: [Int:String])
}

extension AddStepsCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadImg?.image = image
            self.generateImagePathFromDatabase(img: image) { (data) in
                self.delegate?.didChooseImage(data: [self.cellAtIndex! : data])
            }
        }
        self.getVC().dismiss(animated: true, completion: nil)
    }
    
    
    func generateImagePathFromDatabase(img: UIImage, completion: @escaping (_ data: String) -> ()){
        let data = UIImageJPEGRepresentation(img, 0.6)
        let uid = Auth.auth().currentUser?.uid
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imgStorage = Storage.storage().reference().child("recipes").child(uid!).child("\(img).jpg")
        
        let uploadTask = imgStorage.putData(data!, metadata: metaData) { (metadata,err) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }else {
                print("uploaded")
                
                imgStorage.downloadURL(completion: { (url, err) in
                    guard let downloadUrl = url?.absoluteString else {return}
                    completion(downloadUrl)
                })
            }
        }
        
        uploadTask.resume()
    }
    
}
