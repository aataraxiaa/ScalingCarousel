//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2016-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit
import ScalingCarousel

class Cell: ScalingCarouselCell {}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var carousel: ScalingCarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

typealias CarouselDelegate = ViewController
extension CarouselDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let scalingCell = cell as? ScalingCarouselCell, !scalingCell.hasBeenScaled else { return }
        // Initially scale each collection view cell
        scalingCell.scale(withCarouselInset: 60)
    }
}

typealias CarouselDatasource = ViewController
extension CarouselDatasource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}
