//
//  CustomViewLayout.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 16/08/2024.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, withSectionWidth sectionWidth: CGFloat, itemTypeAt indexPath: IndexPath) -> CustomCollectionViewLayoutItemType
}

enum CustomCollectionViewLayoutItemType {
    case row(height: CGFloat)
    case grid(numberOfColumns: Int, numberOfRows: Int)
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Variables
    private var cachedAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentBounds = CGRect.zero
    weak var delegate: CustomCollectionViewLayoutDelegate?
    
    // MARK: - UICollectionViewLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        let collectionWidth = collectionView.bounds.size.width
        var maxY: CGFloat = 0
        var maxX: CGFloat = 0
        var contentHeight: CGFloat = 0
        var columnWidth: CGFloat = 0
        

        for section in (0..<collectionView.numberOfSections) {
            
            let sectionInset = delegate!.collectionView(collectionView, layout: self, insetForSectionAt: section)
            let interitemSpacing = delegate!.collectionView(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
            let lineSpacing = delegate!.collectionView(collectionView, layout: self, minimumLineSpacingForSectionAt: section)
            let sectionWidth = collectionWidth - sectionInset.left - sectionInset.right
            
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
                       
            
            let headerSize = delegate!.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: section)
            
            if headerSize.width > 0,
               headerSize.height > 0 {
                let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: section))
                headerAttributes.frame = CGRect(x: sectionInset.left,
                                                y: maxY,
                                                width: headerSize.width,
                                                height: headerSize.height)
                sectionAttributes.append(headerAttributes)
            }
            
            maxY = maxY + headerSize.height + sectionInset.top
            maxX = sectionInset.left

            var lastFrame: CGRect = CGRect(x: maxX, y: maxY, width: 0, height: 0)

            for currentIndex in (0..<collectionView.numberOfItems(inSection: section)) {
                
                let indexPath = IndexPath(item: currentIndex, section: section)
                
                let itemType = delegate!.collectionView(collectionView, layout: self, withSectionWidth: sectionWidth, itemTypeAt: indexPath)
                
                let itemSize: CGSize = {
                    switch itemType {
                    case .row(let height):
                        return CGSize(width: sectionWidth, height: height)
                    case .grid(let numberOfColumnsForItem, let numberOfRowsForItem):
                        let numberOfColumns: CGFloat = 2
                        let numberOfColumnsForItem = CGFloat(numberOfColumnsForItem)
                        let numberOfRowsForItem = CGFloat(numberOfRowsForItem)
                                                
                        columnWidth = {
                            var availableWidth: CGFloat = collectionView.bounds.width
                            availableWidth -= (sectionInset.left + sectionInset.right)
                            availableWidth -= (numberOfColumns - 1) * interitemSpacing
                            return availableWidth / numberOfColumns
                        }()
                                       
                        return CGSize(width: columnWidth * numberOfColumnsForItem + (numberOfColumnsForItem - 1) * interitemSpacing,
                                      height: columnWidth * numberOfRowsForItem + (numberOfRowsForItem - 1) * lineSpacing)
                    }
                }()
                
                
                var x = lastFrame.maxX + interitemSpacing
                var y = lastFrame.minY
                
                if x + itemSize.width > collectionWidth - sectionInset.right {
                    x = lastFrame.minX
                    y = lastFrame.maxY + lineSpacing
                }
                
                lastFrame = CGRect(origin: .init(x: x, y: y), size: itemSize)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = lastFrame
                
                sectionAttributes.append(attributes)
                maxY = max(maxY, attributes.frame.maxY)
                contentBounds = contentBounds.union(lastFrame)
                
                
                print("🦷 indexPath: \(section)-\(currentIndex) frame: \(lastFrame)")
            }
            
            
            
            contentHeight += sectionInset.bottom
                
            maxY = maxY + sectionInset.bottom
            
            cachedAttributes.append(sectionAttributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for sectionAttributes in cachedAttributes {
            for attributes in sectionAttributes {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes

//        var attributesArray = [UICollectionViewLayoutAttributes]()
//        
//        // Find any cell that sits within the query rect.
//        guard let lastIndex = cachedAttributes.indices.last,
//              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
//        
//        // Starting from the match, loop up and down through the array until all the attributes
//        // have been added within the query rect.
//        for sectionAttributes in cachedAttributes {
//            for attributes in sectionAttributes[..<firstMatchIndex].reversed() {
//                guard attributes.frame.maxY >= rect.minY else { break }
//                attributesArray.append(attributes)
//            }
//        }
//        
//        for sectionAttributes in cachedAttributes {
//            for attributes in sectionAttributes[firstMatchIndex...] {
//                guard attributes.frame.minY <= rect.maxY else { break }
//                attributesArray.append(attributes)
//            }
//        }
//        
//        return attributesArray
    }

    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.section][indexPath.item]
    }
    
//    private func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
//        if start > end { return nil }
//        
//        let mid = (start + end) / 2
//        let attributes = cachedAttributes[mid]
//        
//        if attributes.frame.intersects(rect) {
//            return mid
//        } else if attributes.frame.maxY < rect.minY {
//            return binSearch(rect, start: mid + 1, end: end)
//        } else {
//            return binSearch(rect, start: start, end: mid - 1)
//        }
//    }
}

