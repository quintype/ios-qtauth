//
//  ImagePickerHelper.swift
//  QTAuth
//
//  Created by sunilreddy on 18/03/20.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, fileName: String?, imageType: String?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect info: [UIImagePickerController.InfoKey: Any]?) {
        controller.dismiss(animated: true, completion: nil)
        guard let infoData = info else { return}
        var imageName: String?
        var fileType: String?
        if #available(iOS 11.0, *) {
            if let url = infoData[UIImagePickerController.InfoKey.imageURL] as? URL {
                let name = url.lastPathComponent.split(separator: ".").map(String.init).first
                imageName = name
                fileType = url.pathExtension
            }
            
        } else {
            // Fallback on earlier versions
            if let url = infoData[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let name = url.lastPathComponent.split(separator: ".").map(String.init).first
                imageName = name
                fileType = url.pathExtension
            }
            
        }
        guard let image = infoData[.editedImage] as? UIImage else {
            return
        }
        self.delegate?.didSelect(image: image, fileName: imageName, imageType: fileType)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController,
                                         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.pickerController(picker, didSelect: info)
       }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
