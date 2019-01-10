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
 ScalingCarouselLayout is used together with SPBCarouselView to
 provide a carousel-style collection view.
*/
open class ScalingCarouselLayout: UICollectionViewFlowLayout {

    open var inset: CGFloat = 0.0
    
    /// Initialize a new carousel-style layout
    ///
    /// - parameter inset: The carousel inset
    ///
    /// - returns: A new carousel layout instance
    convenience init(withCarouselInset inset: CGFloat = 0, andScrollDirection direction: UICollectionView.ScrollDirection = .horizontal) {
        self.init()
        self.inset = inset
        self.scrollDirection = direction
    }
    
    override open func prepare() {
        
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        // Set paging
        collectionView?.isPagingEnabled = true
        
        // Set itemSize based on total width and inset
        itemSize = collectionViewSize
        if scrollDirection == .horizontal {
            itemSize.width -= inset * 2
        } else {
            itemSize.height -= inset * 2
        }
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        sectionInset = UIEdgeInsets(top: scrollDirection == .vertical ? inset : 0, left: scrollDirection == .horizontal ? inset : 0, bottom: scrollDirection == .vertical ? inset : 0, right: scrollDirection == .horizontal ? inset : 0)
        footerReferenceSize = .zero
        headerReferenceSize = .zero
    }
}
