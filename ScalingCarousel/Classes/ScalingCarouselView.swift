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

    // MARK: - Properties (Private)

    private var lastCurrentCenterCellIndex: IndexPath?
    
    // MARK: - Properties (Public)
    
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    /// Inset of the main, center cell
    @IBInspectable public var inset: CGFloat = 0.0 {
        didSet {
            /*
             Configure our layout, and add more
             constraints to our invisible UIScrollView
            */
            configureLayout()
        }
    }
    
    /// Returns the current center cell of the carousel if it can be calculated
    open var currentCenterCell: UICollectionViewCell? {
        
        let lowerBound = inset - 20
        let upperBound = inset + 20
        
        for cell in visibleCells {
            
            let cellRect = convert(cell.frame, to: nil)
            
            if scrollDirection == .horizontal && cellRect.origin.x > lowerBound && cellRect.origin.x < upperBound  {
                return cell
            } else if scrollDirection == .vertical && cellRect.origin.y > lowerBound && cellRect.origin.y < upperBound {
                return cell
            }
            
        }
        
        return nil
    }
    
    /// Returns the IndexPath of the current center cell if it can be calculated
    open var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else { return nil }
        
        return indexPath(for: currentCenterCell)
    }
    
    /// Override of the collection view content size to add an observer
    override open var contentSize: CGSize {
        didSet {
            
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            
            // Calculate total number of items in collection view
            var numberItems = 0
            
            for i in 0..<numberSections {
                
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            
            // Set the invisibleScrollView contentSize width based on number of items
            if scrollDirection == .horizontal {
                let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
                invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
            } else {
                let contentHeight = invisibleScrollView.frame.height * CGFloat(numberItems)
                invisibleScrollView.contentSize = CGSize(width: invisibleScrollView.frame.width, height: contentHeight)
            }
        }
    }
    
    // MARK: - Properties (Private)
    fileprivate var invisibleScrollView: UIScrollView!
    fileprivate var invisibleWidthOrHeightConstraint: NSLayoutConstraint?
    fileprivate var invisibleLeftOrTopConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        invisibleScrollView.setContentOffset(rect.origin, animated: animated)
    }
    
    override open func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        var origin = (CGFloat(indexPath.item) * (frame.size.width - (inset * 2)))
        var rect = CGRect(x: origin, y: 0, width: frame.size.width - (inset * 2), height: frame.height)
        if scrollDirection == .vertical {
            origin = (CGFloat(indexPath.item) * (frame.size.height - (inset * 2)))
            rect = CGRect(x: 0, y: origin, width: frame.width, height: frame.size.height - (inset * 2))
        }
        scrollRectToVisible(rect, animated: animated)
        lastCurrentCenterCellIndex = indexPath
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addInvisibleScrollView(to: superview)
    }
    
    // MARK: - Public API
    
    /*
     This method should ALWAYS be called from the ScalingCarousel delegate when
     the UIScrollViewDelegate scrollViewDidScroll(_:) method is called
     
     e.g In the ScalingCarousel delegate, implement:
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
     }
    */
    public func didScroll() {
        scrollViewDidScroll(self)
    }

    /*
     This method should ALWAYS be called from the ViewController that handles the ScalingCarousel when
     the viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) method is called

     e.g Implement:

     func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
     super.viewWillTransition(to: size, with: coordinator)
     carousel.deviceRotated()
     }
     */
    public func deviceRotated() {
        guard let lastCurrentCenterCellIndex = currentCenterCellIndex ?? lastCurrentCenterCellIndex else { return }
        DispatchQueue.main.async {
            self.reloadData()
            var position: UICollectionView.ScrollPosition = .centeredHorizontally
            if self.scrollDirection == .vertical {
                position = .centeredVertically
            }
            self.scrollToItem(at: lastCurrentCenterCellIndex, at: position, animated: false)
            self.didScroll()
        }
    }
}

private typealias PrivateAPI = ScalingCarouselView
fileprivate extension PrivateAPI {
    
    func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else { return }
        
        /// Add our 'invisible' scrollview
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        invisibleScrollView.showsVerticalScrollIndicator = false
        
        /*
         Disable user interaction on the 'invisible' scrollview,
         This means touch events will fall through to the underlying UICollectionView
         */
        invisibleScrollView.isUserInteractionEnabled = false
        
        /// Set the scroll delegate to be the ScalingCarouselView
        invisibleScrollView.delegate = self
        
        /*
         Now add the invisible scrollview's pan
         gesture recognizer to the ScalingCarouselView
         */
        addGestureRecognizer(invisibleScrollView.panGestureRecognizer)
        
        /*
         Finally, add the 'invisible' scrollview as a subview
         of the ScalingCarousel's superview
        */
        superview.addSubview(invisibleScrollView)
        
        /*
         Add constraints for height and top, relative to the
         ScalingCarouselView
        */
        if scrollDirection == .horizontal {
            invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        } else {
            invisibleScrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            invisibleScrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
        /*
         Further configure our layout and add more constraints
         for width and left position
        */
        configureLayout()
    }
    
    func configureLayout() {
        
        // Create a ScalingCarouselLayout using our inset
        collectionViewLayout = ScalingCarouselLayout(
            withCarouselInset: inset)
        
        /*
         Only continue if we have a reference to
         our 'invisible' UIScrollView
        */
        guard let invisibleScrollView = invisibleScrollView else { return }
    
        // Remove constraints if they already exist
        invisibleWidthOrHeightConstraint?.isActive = false
        invisibleLeftOrTopConstraint?.isActive = false
        
        /*
         Add constrants for width and left postion
         to our 'invisible' UIScrollView if scroll Direction is horizontal
         height and top position if scroll Direction is vertical
        */
        if scrollDirection == .horizontal {
            invisibleWidthOrHeightConstraint = invisibleScrollView.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2 * inset))
            invisibleLeftOrTopConstraint =  invisibleScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset)
        } else  {
            invisibleWidthOrHeightConstraint = invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor, constant: -(2 * inset))
            invisibleLeftOrTopConstraint =  invisibleScrollView.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        }
        // Activate the constraints
        invisibleWidthOrHeightConstraint?.isActive = true
        invisibleLeftOrTopConstraint?.isActive = true
        
        
        // To avoid carousel moving when cell is tapped
        isPagingEnabled = true
        isScrollEnabled = false
    }
}

/*
 Scroll view delegate extension used to respond to scrolling of the invisible scrollView
 */
private typealias InvisibleScrollDelegate = ScalingCarouselView
extension InvisibleScrollDelegate: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
         Move the ScalingCarousel base d on the
         contentOffset of the 'invisible' UIScrollView
        */
        updateOffSet()
        
        // Also, this is where we scale our cells
        for cell in visibleCells {
            if let infoCardCell = cell as? ScalingCarouselCell {
                infoCardCell.scale(withCarouselInset: inset)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        guard let indexPath = currentCenterCellIndex else { return }
        lastCurrentCenterCellIndex = indexPath
    }
    
    private func updateOffSet() {
        contentOffset = invisibleScrollView.contentOffset
    }
}
