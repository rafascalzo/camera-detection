//
//  ViewController.swift
//  camera-detection
//
//  Created by rafaelviewcontroller on 9/28/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        /// Start up the camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("need a real device to test this feature");
            return
        }
        
        startCapture(captureDevice, captureSession)
    }
    
    // MARK: - Private methods
    fileprivate func startCapture(_ captureDevice: AVCaptureDevice, _ captureSession: AVCaptureSession) {
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            captureSession.startRunning()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = view.frame
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(dataOutput)
            
            /*
             let request = VNCoreMLRequest(model: <#T##VNCoreMLModel#>, completionHandler: <#T##VNRequestCompletionHandler?##VNRequestCompletionHandler?##(VNRequest, Error?) -> Void#>)
             VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
             */
        }catch {
            print(Error.self, "no camera permissions")
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Camera was able to capture a frame", Date())
        
        guard let pixelBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            print(finishedRequest.results!)
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
