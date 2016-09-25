//
//  ScalingCarouselView.swift
//  Bikey
//
//  Created by Pete Smith on 17/09/2016.
//  Copyright © 2016 Pete Smith. All rights reserved.
//

import UIKit


/*
 Scaling carousel view is a subclass of UICollectionView.
 It is intended to be used to to carousel through cells which don't 
 extend to the edges of a screen. The previous and subsequent cells
 are scaled as the collection view scrolls.
 
*/
class ScalingCarouselView: UICollectionView {
    
    // MARK: - Properties (Public)
    
    
    /// Inset of the main, central cell
    @IBInspectable var inset: CGFloat = 0.0 {
        didSet {
            collectionViewLayout = ScalingCarouselLayout(withCarouselInset: inset)
        }
    }
    
    
    /// Override of the collection view content size to add an observer
    override var contentSize: CGSize {
        didSet {
            invisibleScrollView.contentSize = contentSize
        }
    }
    
    // MARK: - Properties (Private)
    fileprivate var invisibleScrollView: UIScrollView!

    // MARK: - Lifecycle
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    // MARK: - Overrides
    
    override func updateConstraints() {
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2 * inset)).isActive = true
        invisibleScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        
        super.updateConstraints()
    }
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: false)
    }
    
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: false)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        // Add our invisible scrollview
        invisibleScrollView = UIScrollView(frame: self.bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        // Turn off interaction on the overlay so touch events fall through to the main scroll view
        invisibleScrollView.isUserInteractionEnabled = false
        invisibleScrollView.delegate = self
        // Add the disabled invisible scrollviews pan gesture recognizer to our collection view
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        addSubview(invisibleScrollView)
    }
}


/*
 Scroll view delegate extension used to respond to scrolling of the invisible scrollView
*/
private typealias InvisibleScrollDelegate = ScalingCarouselView
extension InvisibleScrollDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.scrollViewDidScroll?(scrollView)
        
        // Only move the collection view by an amount based on the invisible scrollview
        updateOffSet()
        
        // Scale Visible cells
        for cell in visibleCells {
            cell.scale(withCarouselInset: inset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}
