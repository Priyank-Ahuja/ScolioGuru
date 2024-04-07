//
//  SGCameraViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 4/6/24.
//

import UIKit
import SensorKit

class SGCameraViewController: UIViewController {
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var imageOverlayView: UIImageView!
    @IBOutlet weak var preAnalysisParamsStack: UIStackView!
    
    @IBOutlet weak var instructionStackView: UIStackView!
    var session: AVCaptureSession?
    var ambientLightSensor: SRSensor?
    var photoOutput = AVCapturePhotoOutput()
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    let model: SGCameraViewModel
    var imageView: UIImageView?
    
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
        
        setupInterface()
        setupShutterButton()
        checkCameraPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
    }
    
    private func setupInterface() {
        shutterButton.setTitle("Take a Snap", for: .normal)
        updateParamsStack()
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
        self.updateParamsStack()
        guard let imageView else {return}

        imageView.removeFromSuperview()
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
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
        if let device = AVCaptureDevice.default(for: .video) {
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
        
        let paramsError = model.getParamsError(of: cgImage)
        self.updateParamsStack()
        if paramsError.isError {
            self.showRetakeAlert(error: paramsError)
        }
    }
    
}
