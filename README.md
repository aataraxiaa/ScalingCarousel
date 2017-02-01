# ScalingCarousel

[![CI Status](http://img.shields.io/travis/Pete Smith/ScalingCarousel.svg?style=flat)](https://travis-ci.org/Pete Smith/ScalingCarousel)
[![Version](https://img.shields.io/cocoapods/v/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)
[![License](https://img.shields.io/cocoapods/l/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)
[![Platform](https://img.shields.io/cocoapods/p/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)

ScalingCarousel provides a simple carousel-style collection view.
It takes care of cell presentation, scaling each cell as the collection view is scrolled.

It is used in [Bikey](https://itunes.apple.com/ie/app/bikey/id1048962300?mt=8) to present bike station information, as seen below;

![Bikey ScalingCarousel example](Images/BikeyExample.gif)

## Usage

ScalingCarousel can be added via both storyboard/xib and code, as described below.

### Storyboard

* Add a UICollectionView to your view, and change the type to ScalingCarouselView

* In the attributes inspector, set the desired carousel inset

* Set your UIViewController as the collection view datasource and implement the standard UICollectionViewDatasource methods in your view controller

* Set your UIViewController as the collection view delegate and implement the UIScrollViewDelegate method scrollViewDidScroll(:). In this method, call the didScroll() method of ScalingCarouselView

* Create a custom UICollectionViewCell which inherits from ScalingCarouselCell, and set the cell type to your custom cell type in the storyboard

* Add a view to the cell's content view, and connect this via the Connections Inspector (in Interface builder) to the cell's mainView IBOutlet.
This property is declared in ScalingCarouselCell. You should add any cell content to this view.

### Code

* Create a custom UICollectionViewCell which inherits from ScalingCarouselCell. Initialize the mainView property, which is declared in ScalingCarouselCell;

```
override init(frame: CGRect) {
  super.init(frame: frame)

  // Initialize the mainView property and add it to the cell's contentView
  mainView = UIView(frame: contentView.bounds)
  contentView.addSubview(mainView)
}
```

* Create and add a ScalingCarouselView to your view, and implement the standard UICollectionViewDatasource methods in your view controller;

```
// Create our carousel
let scalingCarousel = ScalingCarouselView(withFrame: frame, andInset: 20)
scalingCarousel.dataSource = self
scalingCarousel.translatesAutoresizingMaskIntoConstraints = false

// Register our custom cell for dequeueing
scalingCarousel.register(Cell.self, forCellWithReuseIdentifier: "cell")

// Add our carousel as a subview        
view.addSubview(scalingCarousel)

// Add Constraints
scalingCarousel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
scalingCarousel.heightAnchor.constraint(equalToConstant: 300).isActive = true
scalingCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
scalingCarousel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
```

* Set your UIViewController as the collection view delegate and implement the UIScrollViewDelegate method scrollViewDidScroll(:). In this method, call the didScroll() method of ScalingCarouselView

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 9

## Installation

ScalingCarousel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ScalingCarousel"
```

## Author

Pete Smith, peadar81@gmail.com

## License

ScalingCarousel is available under the MIT license. See the LICENSE file for more info.
