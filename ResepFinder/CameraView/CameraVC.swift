//
//  CameraVC.swift
//  ResepFinder
//
//  Created by William Huang on 17/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class CameraVC: RFBaseController {

    let cameraView: UIView = {
        let imgView = UIView()
        imgView.backgroundColor = .white
        return imgView
    }()
    
    let captureView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        return view
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.isUserInteractionEnabled = true
        btn.setTitleColor(RFColor.instance.black, for: .normal)
        btn.setTitle("Cancel", for: .normal)
        return btn
    }()
    
    var captureSession : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var photoData: Data?
    private var delegate: CameraFinishingProtocol?
    var context = CIContext(options: nil)
    
    convenience init(delegate: CameraFinishingProtocol){
        self.init()
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        initializeCameraSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.frame
    }
    
    func initializeCameraSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true{
                captureSession.addInput(input)
            }
            captureSession.startRunning()
            
            cameraOutput = AVCapturePhotoOutput()
            cameraOutput.isHighResolutionCaptureEnabled = true
            
            if captureSession.canAddOutput(cameraOutput) == true{
                
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                //previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                //previewLayer.connection?.videoOrientation = .portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                
            }
            captureSession.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapCameraView(){
        self.cameraView.isUserInteractionEnabled = false
        
        let settings = AVCapturePhotoSettings()
        settings.isAutoStillImageStabilizationEnabled = true
        settings.isHighResolutionPhotoEnabled = true
        //        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first
        //
        //        let previewFormat = [
        //            kCVPixelBufferPixelFormatTypeKey as String :previewPixelType,
        //            kCVPixelBufferWidthKey as String: 160,
        //            kCVPixelBufferHeightKey as String : 160
        //        ]
        
        
        //settings.previewPhotoFormat = previewFormat
        //settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }

}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
//                if let image = UIImage(data: dataImage) {
//                    //self.capturedImage.image = image
//                }
            }
        }
        
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            debugPrint(error as Any)
        }else{
            photoData = photo.fileDataRepresentation()
//            let img = UIImage(data: photoData!)
//
//            var inputImage = CIImage(image: img!)
//            let options:[String : AnyObject] = [CIDetectorImageOrientation:3 as AnyObject]
//            let filters = inputImage!.autoAdjustmentFilters(options: options)
//
//            for filter: CIFilter in filters {
//                filter.setValue(inputImage, forKey: kCIInputImageKey)
//                inputImage =  filter.outputImage
//            }
//            let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
//
//            //Apply noir Filter
//            let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
//            currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
//
//            let output = currentFilter!.outputImage
//            let cgimg = context.createCGImage(output!, from: output!.extent)
            
            
            do {
                let model = try VNCoreMLModel(for: resepFinder().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    @available(iOS 11.0, *)
    func resultsMethod(request: VNRequest, error: Error?){
        //handle changing label text
        guard let results = request.results as? [VNClassificationObservation] else {return}
        for classification in results {
            if classification.confidence >= 0.50 {
                let confindence = Int(classification.confidence * 100)
                let completeSentence = "This looks like a \(classification.identifier) and I am \(confindence) percent sure."
                print(completeSentence)
                
                //self.navigateToSearchResult(byTitle: classification.identifier)
                self.dismissToPreviousScreen()
                self.delegate?.getPhotoIdentifier(byTitle: classification.identifier, identifier: self)
                break
            }
        }
        
    }
}
    

extension CameraVC {
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        configureView()
        layoutViews()
    }
    
    fileprivate func configureView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1
        captureView.addGestureRecognizer(tap)
        
        self.cancelBtn.addTarget(self, action: #selector(self.dismissToPreviousScreen), for: .touchUpInside)
    }
    
    
    fileprivate func layoutViews(){
        self.view.addSubview(cameraView)
        self.view.addSubview(captureView)
        self.view.addSubview(cancelBtn)
        //self.cameraView.bringSubview(toFront: captureView)
        //self.cameraView.bringSubview(toFront: cancelBtn)
        
        _ = cameraView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        _ = captureView.anchor(bottom: self.view.bottomAnchor, bottomConstant: 18, widthConstant: 60, heightConstant: 60)
        _ = captureView.centerConstraintWith(centerX: self.view.centerXAnchor)
        _ = cancelBtn.anchor(left: self.view.leftAnchor, leftConstant: 32)
        _ = cancelBtn.centerConstraintWith(centerY: self.captureView.centerYAnchor)
    }
}


protocol CameraFinishingProtocol {
    func getPhotoIdentifier(byTitle title: String, identifier: RFBaseController)
}
