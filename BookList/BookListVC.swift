//
//  BookListVC.swift
//  BookList
//
//  Created by Megat Syafiq on 05/02/2020.
//  Copyright © 2020 Megat Syafiq. All rights reserved.
//

import UIKit
struct Book {
    var title : String
    var cover : String
}
class BookListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var arrayData = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBookList(fileName: "data")
        collectionView.delegate = self
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    func getBookList(fileName:String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? NSArray {
                    for data in jsonResult {
                        if let obj = data as? NSDictionary {
                            let bookTitle = obj["title"] as? String
                            let bookCover = obj["cover"] as? String
                            
                            let list = Book(title: bookTitle!, cover: bookCover!)
                            
                            self.arrayData.append(list)
                            print(self.arrayData)
                        }
                    }
                    self.collectionView.reloadData()
                }
            } catch {
                
            }
        }
    }
    
}

extension BookListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = arrayData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellbook", for: indexPath) as? BookListCVC
        
        cell?.bookCoverImage.image = UIImage(named: data.cover)
        cell?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 0)) / 2
        return CGSize(width: itemSize, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            
            let data = arrayData[index.row]
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let desVC = mainStoryboard.instantiateViewController(withIdentifier: "bookinfo") as! BookInfoVC
            
            desVC.titleBook = data.title
            desVC.coverBook = data.cover
        
            self.navigationController?.pushViewController(desVC, animated: true)
        }
    }
    
    
}
