//
//  AlbumCollectionVC.swift
//  AlbumScreen
//
//  Created by shyam-8423 on 17/10/22.
//

import AlamofireURLCache
import UIKit

class AlbumCollectionVC: UICollectionViewController {
    let unsplashUrl: String = "https://source.unsplash.com/random"
    let albumCount = 200
    var album: [UIImage] = []
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let minSpacing: CGFloat = 20
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 0, height: 0)
        layout.scrollDirection = .vertical
        layout.sectionInset = insets
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Album"
        self.registerCells()
        self.saveDataForAlbum()
    }
    
    deinit {
        print("\(self.classForCoder) has been Deinitialised")
    }
}

extension AlbumCollectionVC {
    func registerCells() {
        let nib = UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifer)
        self.collectionView.collectionViewLayout = self.generateLayout()
    }
    
    func saveDataForAlbum() {
        if let url = URL(string: unsplashUrl) {
            for _ in 0 ... self.albumCount {
                var urlRequest = URLRequest(url: url)
                AlamofireURLCache.clearCache(request: urlRequest)
                urlRequest.cachePolicy = .reloadIgnoringCacheData
                URLCache.shared.removeAllCachedResponses()
                AlamofireURLCache.request(self.unsplashUrl, refreshCache: true).responseData (completionHandler: { response in
                    switch response.result {
                    case let .success(data):
                        print(data)
                        if let image = UIImage(data: data) {
                            self.album.append(image)
                            if self.album.count == self.albumCount {
                                self.activityIndicator.stopAnimating()
                                self.collectionView.reloadData()
                            }
                        }
                    case let .failure(error):
                        assertionFailure("\(error)")
                        self.activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
                    }
                }, autoClearCache: true).cache(maxAge: 1, isPrivate: true, ignoreServer: true)
            }
        }
    }
}

extension AlbumCollectionVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.activityIndicator.isAnimating ? 0 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityIndicator.isAnimating ? 0 : self.albumCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifer,
            for: indexPath
        )
        guard let albumCollectionViewCell = cell as? AlbumCollectionViewCell else {
            return cell
        }
        albumCollectionViewCell.configure(with: self.album[indexPath.item])
        return albumCollectionViewCell
    }
}

extension AlbumCollectionVC {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/2))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: fullPhotoItem,
            count: 2
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
