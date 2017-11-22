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
    @IBInspectable public var cornerRadius: CGFloat = 10

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
    open func scale(withCarouselInset carouselInset: CGFloat,
                    scaleMinimum: CGFloat = 0.9) {

        // Ensure we have a superView, and mainView
        guard let superview = superview,
            let mainView = mainView else { return }

        // Get our absolute origin value
        let originX = superview.convert(frame, to: nil).origin.x

        // Calculate our actual origin.x value using our inset
        let originXActual = originX - carouselInset

        let width = frame.size.width

        // Calculate our scale values
        let scaleCalculator = fabs(width - fabs(originXActual))
        let percentageScale = (scaleCalculator/width)

        let scaleValue = scaleMinimum
            + (percentageScale/InternalConstants.scaleDivisor)

        let alphaValue = InternalConstants.alphaSmallestValue
            + (percentageScale/InternalConstants.scaleDivisor)

        let affineIdentity = CGAffineTransform.identity

        // Scale our mainView and set it's alpha value
        mainView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
        mainView.alpha = alphaValue

        // ..also..round the corners
        mainView.layer.cornerRadius = cornerRadius
    }
}
