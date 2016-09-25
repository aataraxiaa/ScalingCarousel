//
//  UICollectionViewCell+ScalingCarouselCell.swift
//  Bikey
//
//  Created by Pete Smith on 17/09/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import UIKit


/* 
 This extension is intended to be used together with SPBCarouselView
 
 This UICollectionViewCell extenstion adds a methods used to scale the cell
 in relation to the cell's position in the top level window.
 
 Collection view cells used with SPBCarouselView should use this method to
 scale when scrolled.
*/
typealias ScalingCarouselCell = UICollectionViewCell
extension ScalingCarouselCell {
    
    private struct InternalConstants {
        static let alphaSmallestValue: CGFloat = 0.85
        static let scaleDivisor: CGFloat = 10.0
    }
    
    /// Scale the cell when it is scrolled
    ///
    /// - parameter carouselInset: The inset of the related SPBCarousel view
    /// - parameter scaleMinimum:  The minimun % a cell should scale to, 
    ///             expressed as a value between 0.0 and 1.0
    func scale(withCarouselInset carouselInset: CGFloat, scaleMinimum: CGFloat = 0.9) {
        let originX = convert(contentView.frame, to: nil).origin.x
        
        let originXActual = originX - carouselInset
        
        let width = contentView.frame.size.width
        
        let scaleCalculator = fabs(width - fabs(originXActual))
        
        let percentageScale = (scaleCalculator/width)
        
        let scaleValue = scaleMinimum + (percentageScale/InternalConstants.scaleDivisor)
        let alphaValue = InternalConstants.alphaSmallestValue + (percentageScale/InternalConstants.scaleDivisor)
        
        transform = CGAffineTransform.identity.scaledBy(x: scaleValue, y: scaleValue)
        alpha = alphaValue
        
        setNeedsLayout()
    }
}
