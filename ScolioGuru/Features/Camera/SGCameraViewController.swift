//
//  SGCameraViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/6/24.
//

import UIKit
import SensorKit

final class SGCameraViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextViewButton: SGButton!
    @IBOutlet weak var anotherAngleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var imageOverlayView: UIImageView!
    @IBOutlet weak var preAnalysisParamsStack: UIStackView!
    @IBOutlet weak var headerView: SGHeaderView!
    
    var session: AVCaptureSession?
    var ambientLightSensor: SRSensor?
    var photoOutput = AVCapturePhotoOutput()
    var imagePicker = UIImagePickerController()
    var imageView: UIImageView?
    var backButtonClosure: VoidClosure?
    var timer = Timer()
    var counter = 5
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    let model: SGCameraViewModel
   
    init(model: SGCameraViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(previewLayer, at: 0)
        nextViewButton.addShadow()
        setupInterface()
        setupShutterButton()
        checkCameraPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
    }
    
    private func setupInterface() {
        headerView.backButtonClosure = { [weak self] in
            guard let self else { return }
            self.backButtonClosure?()
        }
        self.timerLabel.isHidden = true
        self.timerLabel.text = "\(counter)"
        updateParamsStack()
        setupCameraState()
    }
    
    private func setupCameraState() {
        self.anotherAngleLabel.isHidden = true
        self.shutterButton.isHidden = false
        self.nextViewButton.isHidden = true
        self.descriptionLabel.numberOfLines = 5
        switch model.state {
        case .preImage:
            self.imageOverlayView.image = UIImage(named: "camera-overlay")
            
            self.titleLabel.text = "Help Us Analyse Your Surrounding"
            self.titleLabel.textAlignment = .center
            self.descriptionLabel.textAlignment = .center
            
            self.tabBarController?.tabBar.isHidden = false
            self.preAnalysisParamsStack.isHidden = false
        case .manual:
            guard let currentView = model.getCurrentView() else { return }
            self.imageOverlayView.image = UIImage(named: currentView.imageName)
            
            self.titleLabel.text = currentView.title
            self.titleLabel.textAlignment = .left
            self.descriptionLabel.text = currentView.description
            self.descriptionLabel.textAlignment = .left
            
            //self.tabBarController?.removeFromParent()
            self.tabBarController?.tabBar.isHidden = true
            self.preAnalysisParamsStack.isHidden = true
        case .auto:
            guard let currentView = model.getCurrentView() else { return }
            self.imageOverlayView.image = UIImage(named: currentView.imageName)
            
            self.titleLabel.text = currentView.title
            self.titleLabel.textAlignment = .left
            self.descriptionLabel.text = currentView.description
            self.descriptionLabel.textAlignment = .left
            
            //self.tabBarController?.removeFromParent()
            self.tabBarController?.tabBar.isHidden = true
            self.preAnalysisParamsStack.isHidden = true
            self.shutterButton.isHidden = true
            
            self.timerLabel.isHidden = false
            timer.invalidate() // just in case this button is tapped multiple times
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    private func setupImagePreview() {
        self.anotherAngleLabel.isHidden = false
        self.shutterButton.isHidden = true
        self.nextViewButton.isHidden = false
    }
    
    private func showRetakeAlert(error: SGErrorModel) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retake", style: UIAlertAction.Style.default, handler: { (handler) in
            self.retakeHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func retakeHandler() {
        model.resetSurroundingModel()
        updateParamsStack()
        resetImageView()
    }
    
    private func resetImageView() {
        guard let imageView else {return}
        imageView.removeFromSuperview()
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
        }
    }
    
    private func showPhoneAccessAlert() {
        let alert = UIAlertController(title: "Phone Access", message: "We can help take the pictures for you (Auto) or you could have someone help you with it (manual).", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Auto", style: UIAlertAction.Style.default, handler: { (handler) in
            self.autoCameraHandler()
        }))
        alert.addAction(UIAlertAction(title: "Manual", style: UIAlertAction.Style.default, handler: { (handler) in
            self.manualCameraHandler()
        }))
        alert.addAction(UIAlertAction(title: "Upload from galary", style: UIAlertAction.Style.default, handler: { (handler) in
            self.uploadFromGalaryHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func uploadFromGalaryHandler() {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func manualCameraHandler() {
        guard let session else { return }
        self.setupCameraPosition(position: .back, session: session)
        model.state = .manual
        resetImageView()
        setupInterface()
    }
    
    private func autoCameraHandler() {
        guard let session else { return }
        self.setupCameraPosition(position: .front, session: session)
        model.state = .auto
        resetImageView()
        setupInterface()
        
        self.timerLabel.isHidden = false
        
        
        timer.invalidate() // just in case this button is tapped multiple times

        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        if self.counter > 0 {
            timerLabel.text = "\(counter)"
            self.counter -= 1
        } else if self.counter == 0 {
            self.counter = 5
            timerLabel.text = "\(counter)"
            timer.invalidate()
            self.timerLabel.isHidden = true
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
      }
    
    private func updateParamsStack() {
        preAnalysisParamsStack.subviews.forEach({ $0.removeFromSuperview() })
        for params in model.surroundingModel {
            let paramViewModel = SGParameterCheckViewModel(isEnabled: params.isEnabled, title: params.title)
            let view = SGParameterCheckView()
            view.setupInterface(model: paramViewModel)
            preAnalysisParamsStack.addArrangedSubview(view)
        }
    }
    
    private func setupShutterButton() {
        shutterButton.layer.cornerRadius = 22
        shutterButton.setTitleColor(.black, for: .normal)
        shutterButton.addShadow()
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        setupCameraPosition(position: .back, session: session)
    }
    
    private func setupCameraPosition(position: AVCaptureDevice.Position, session: AVCaptureSession) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }
            
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.session = session
            
            DispatchQueue.global(qos: .background).async {
                self.session?.startRunning()
            }
            
            self.session = session
        } catch {
            
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        guard let imageView else {return}
        //self.dismissButton.isHidden = true
        imageView.removeFromSuperview()
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
        }
    }
    
    @IBAction func shutterButtonAction(_ sender: Any) {
        photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @IBAction func nextViewButtonAction(_ sender: Any) {
        model.updateCurrentView()
        if model.goToAnalysis {
            
        } else {
            resetImageView()
            setupCameraState()
        }
    }
}

extension SGCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData),
              let cgImage = image.cgImage else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        session?.stopRunning()
        
        self.imageView = UIImageView(image: image)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.frame = view.bounds
        guard let imageView else { return }
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        switch model.state {
        case .preImage:
            let paramsError = model.getParamsError(of: cgImage)
            self.updateParamsStack()
            if paramsError.isError {
                self.showRetakeAlert(error: paramsError)
            } else {
                self.showPhoneAccessAlert()
            }
        case .manual:
            setupImagePreview()
        case .auto:
            //model.currentViewNumber += 1
            //setupCameraState()
            setupImagePreview()
        }
    }
    
}

extension SGCameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        session?.stopRunning()
        
        self.imageView = UIImageView(image: image)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.frame = view.bounds
        guard let imageView else { return }
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        //imageView.image = image
    }
    
}
