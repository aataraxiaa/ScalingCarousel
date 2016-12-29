//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2017-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

/*
 This cell subclass is intended to be used together with ScalingCarouselView
 
 This class adds a method used to scale the cell
 in relation to the cell's position in the top level window.
 
 Collection view cells used with ScalingCarouselView should subclass this type
 */
open class ScalingCarouselCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    // This property should be connected to the main cell subview
    @IBOutlet public var mainView: UIView!
    
    private struct InternalConstants {
        static let alphaSmallestValue: CGFloat = 0.85
        static let scaleDivisor: CGFloat = 10.0
    }
    
    // MARK: - Overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard let carouselView = superview as? ScalingCarouselView else { return }
        
        scale(withCarouselInset: carouselView.inset)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        mainView.transform = CGAffineTransform.identity
        mainView.alpha = 1.0
    }
    
    /// Scale the cell when it is scrolled
    ///
    /// - parameter carouselInset: The inset of the related SPBCarousel view
    /// - parameter scaleMinimum:  The minimun % a cell should scale to,
    ///             expressed as a value between 0.0 and 1.0
    open func scale(withCarouselInset carouselInset: CGFloat, scaleMinimum: CGFloat = 0.9) {
        guard let superview = superview, let mainView = mainView else { return }
        
        print("\n******")
        
        print("frame: \(frame)")
        print("bounds: \(bounds)")
        print("mainView.frame: \(mainView.frame)")
        print("mainView.bounds: \(mainView.bounds)")
        
        let originX = superview.convert(frame, to: nil).origin.x
        
        print("originX: \(originX))")
        
        let originXActual = originX - carouselInset
        
        print("originXActual: \(originXActual))")
        
        let width = frame.size.width
        
        print("frame width: \(width)")
        print("mainView frame width: \(mainView.frame.size.width)")
        
        let scaleCalculator = fabs(width - fabs(originXActual))
        
        print("scaleCalculator: \(scaleCalculator)")
        
        let percentageScale = (scaleCalculator/width)
        
        print("percentageScale: \(percentageScale)")
        
        let scaleValue = scaleMinimum + (percentageScale/InternalConstants.scaleDivisor)
        let alphaValue = InternalConstants.alphaSmallestValue + (percentageScale/InternalConstants.scaleDivisor)
        
        print("scaleValue: \(scaleValue))")
        
        mainView.transform = CGAffineTransform.identity.scaledBy(x: scaleValue, y: scaleValue)
        mainView.alpha = alphaValue
        mainView.layer.cornerRadius = 20
        
        print("******")
    }
}
