//
//  ScalingCarouselLayout.swift
//  Bikey
//
//  Created by Pete Smith on 17/09/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import UIKit

/*
 ScalingCarouselLayout is used together with SPBCarouselView to
 provide a carousel-style collection view.
*/
class ScalingCarouselLayout: UICollectionViewFlowLayout {
    
    var inset: CGFloat = 0.0
    
    
    /// Initialize a new carousel-style layout
    ///
    /// - parameter inset: The carousel inset
    ///
    /// - returns: A new carousel layout instance
    convenience init(withCarouselInset inset: CGFloat = 0.0) {
        self.init()
        self.inset = inset
    }
    
    override func prepare() {
        guard let collectionViewSize = collectionView?.frame.size else { return }
        
        itemSize = collectionViewSize
        itemSize.width = itemSize.width - (inset * 2)
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        
        sectionInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        footerReferenceSize = CGSize.zero
        headerReferenceSize = CGSize.zero
    }
}
