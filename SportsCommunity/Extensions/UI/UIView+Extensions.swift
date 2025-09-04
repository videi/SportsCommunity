//
//  UIView+Extensions.swift
//  SportsCommuinty
//
//  Created by Илья Макаров on 03.11.2024.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension UIView {
    private struct ViewPreview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
    
    func showLivePreview() -> some View {
        ViewPreview(view: self)
    }
}
#endif

extension UIView {
    func getSubviews<T: UIView>(of type: T.Type) -> [T] {
        var result = [T]()
        
        for subview in subviews {
            if let match = subview as? T {
                result.append(match)
            }
            result.append(contentsOf: subview.getSubviews(of: type))
        }
        
        return result
    }
}
