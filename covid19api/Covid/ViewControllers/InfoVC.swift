//
//  InfoVC.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import UIKit
import Network

class InfoVC: UIViewController {
    // MARK: IBOulets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Variables
    private var path = "/N9p5hsImWXAccRNI/arcgis/rest/services/Nc2JKvYFoAEOFCG5JSI6/FeatureServer/2/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc&resultOffset=0&resultRecordCount=300&resultType=standard&cacheHint=true"
    private var regions = [Feature]()
    var networkCheck = NetworkCheck.sharedInstance()
    
    // MARK: Object life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = self.getSavedData() {
            self.regions = data
            collectionView.reloadData()
        }
        if networkCheck.currentStatus == .satisfied {
            getInfo()
        }else{
            self.alert(title: "Please check your internet connection.")
        }
        networkCheck.addObserver(observer: self)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

// MARK: Class methods
extension InfoVC {
    func getInfo() {
        let service = GetInfoService(path: self.path)
        service.execute(success: { [weak self] response in
            if let attr = response.features {
                self?.regions = attr
                let data = try! NSKeyedArchiver.archivedData(withRootObject: attr, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: "Data")
                self?.collectionView.reloadData()
            }
        }) { error in
            self.alert(title: error.localizedDescription)
        }
    }
    
    func getSavedData() -> [Feature]? {
        let placeData = UserDefaults.standard.data(forKey: "Data")
        guard let data = placeData else {
            return nil
        }
        do {
            if let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Feature] {
                return array
            }
        } catch {
            print("Couldn't read file.")
        }
        return nil
    }

    @objc func rotated() {
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InfoDetailVC {
            guard let attr = sender as? Attribute else{return}
            vc.attribute = attr
        }
    }
}

extension InfoVC: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            if regions.count == 0 {
                getInfo()
            }
        }else if status == .unsatisfied {
            //Show no network alert
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension InfoVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let attr = regions[indexPath.row].attributes{
            performSegue(withIdentifier: "detail", sender: attr)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as! RegionCell
        if let attr = regions[indexPath.row].attributes{
            cell.configure(attr)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 32, height: 60)
    }
}
