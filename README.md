# ScalingCarousel

[![CI Status](http://img.shields.io/travis/Pete Smith/ScalingCarousel.svg?style=flat)](https://travis-ci.org/Pete Smith/ScalingCarousel)
[![Version](https://img.shields.io/cocoapods/v/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)
[![License](https://img.shields.io/cocoapods/l/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)
[![Platform](https://img.shields.io/cocoapods/p/ScalingCarousel.svg?style=flat)](http://cocoapods.org/pods/ScalingCarousel)

ScalingCarousel provides a simple carousel-style collection view.
It takes care of cell presentation, scaling each cell as the collection view is scrolled.

It is used in [Bikey](https://itunes.apple.com/ie/app/bikey/id1048962300?mt=8) to present bike station information.

## Usage

ScalingCarousel can be added via both storyboard/xib and code, as described below.

### Storyboard

1. Add a UICollectionView to your view, and change the type to ScalingCarouselView

2. In the attributes inspector, set the desired carousel inset

3. Set your UIViewController as the collection view datasource and implement the standard UICollectionViewDatasource methods in your view controller

4. Create a custom UICollectionViewCell which inherits from ScalingCarouselCell

5. Set the cell type to your custom cell type in the storyboard

### Code

1. Create and add a ScalingCarouselView to your view as follows;

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

2. Implement the standard UICollectionViewDatasource methods in your view controller

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
