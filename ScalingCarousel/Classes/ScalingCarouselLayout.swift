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

/// ScalingCarouselLayout is used together with SPBCarouselView to
/// provide a carousel-style collection view.
open class ScalingCarouselLayout: UICollectionViewFlowLayout {
    open var inset: CGFloat = 0.0

    /// Initialize a new carousel-style layout
    ///
    /// - Parameter inset: The carousel inset
    /// - Returns: A new carousel layout instance
    convenience init(withCarouselInset inset: CGFloat = 0.0) {
        self.init()
        self.inset = inset
    }

    open override func prepare() {
        guard let collectionViewSize = collectionView?.frame.size else { return }

        // Set itemSize based on total width and inset
        itemSize = collectionViewSize
        itemSize.width = itemSize.width - (inset * 2)

        // Set scrollDirection and paging
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true

        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0

        sectionInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        footerReferenceSize = .zero
        headerReferenceSize = .zero
    }
}
