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
 ScalingCarouselView is a subclass of UICollectionView which
 is intended to be used to carousel through cells which don't
 extend to the edges of a screen. The previous and subsequent cells
 are scaled as the carousel scrolls.
 */
open class ScalingCarouselView: UICollectionView {
    
    // MARK: - Properties (Public)
    
    /// Inset of the main, central cell
    @IBInspectable public var inset: CGFloat = 0.0 {
        didSet {
            collectionViewLayout = ScalingCarouselLayout(withCarouselInset: inset)
        }
    }
    
    /// Override of the collection view content size to add an observer
    override open var contentSize: CGSize {
        didSet {
            
            guard let dataSource = dataSource else { return }
            
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            
            // Calculate total number of items in collection view
            var numberItems = 0
            
            for i in 0..<numberSections {
                
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            
            // Set the invisibleScrollView contentSize width based on number of items
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    // MARK: - Properties (Private)
    fileprivate var invisibleScrollView: UIScrollView!
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    /// Convenience initializer allowing setting of the carousel inset
    ///
    /// - Parameters:
    ///   - frame: Frame
    ///   - inset: Inset
    public convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        self.init(frame: frame, collectionViewLayout: ScalingCarouselLayout(withCarouselInset: inset))
        
        self.inset = inset
    }
    
    // MARK: - Overrides
    
    override open func updateConstraints() {
        
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2 * inset)).isActive = true
        invisibleScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        super.updateConstraints()
    }
    
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override open func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
        let originX = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        let rect = CGRect(x: originX, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        scrollRectToVisible(rect, animated: animated)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        
        // Add our invisible scrollview
        invisibleScrollView = UIScrollView(frame: self.bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        
        
        print("Frame size: \(frame.size)")
        invisibleScrollView.contentSize = frame.size
        
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.scrollViewDidScroll?(scrollView)
        
        // Only move the collection view by an amount based on the invisible scrollview
        updateOffSet()
        
        // Scale Visible cells
        for cell in visibleCells {
            if let infoCardCell = cell as? ScalingCarouselCell {
                infoCardCell.scale(withCarouselInset: inset)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}
