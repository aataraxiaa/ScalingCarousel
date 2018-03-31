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
import ScalingCarousel

class Cell: ScalingCarouselCell {}

class StoryboardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var carouselBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var output: UILabel!
    
    private struct Constants {
        static let carouselHideConstant: CGFloat = -250
        static let carouselShowConstant: CGFloat = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselBottomConstraint.constant = Constants.carouselHideConstant
    }
    
    // MARK: - Button Actions
    
    @IBAction func showHideButtonPressed(_ sender: Any) {
        
        carouselBottomConstraint.constant = (carouselBottomConstraint.constant == Constants.carouselShowConstant ? Constants.carouselHideConstant : Constants.carouselShowConstant)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

typealias CarouselDatasource = StoryboardViewController
extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            scalingCell.mainView.backgroundColor = .red
        }
        
        return cell
    }
}

typealias CarouselDelegate = StoryboardViewController
extension StoryboardViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //carousel.didScroll()
        
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
        
        output.text = String(describing: currentCenterIndex)
    }
}

private typealias ScalingCarouselFlowDelegate = StoryboardViewController
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
