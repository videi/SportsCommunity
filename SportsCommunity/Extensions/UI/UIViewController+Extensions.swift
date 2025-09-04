//
//  UIViewController+Extensions.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 03.11.2024.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension UIViewController {
    
    private struct ControllerPreview: UIViewControllerRepresentable {
        let viewcontroller: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewcontroller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
    func showLivePreview() -> some View {
        ControllerPreview(viewcontroller: self)
    }
}
#endif

extension UIViewController {
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true)
    }
    
    func showAlertOk(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        })
        present(alert, animated: true)
    }
}
