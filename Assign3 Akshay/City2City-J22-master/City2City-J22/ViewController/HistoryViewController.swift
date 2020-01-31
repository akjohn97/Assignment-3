//
//  HistoryViewController.swift
//  City2City-J22
//
//  Created by Consultant on 1/30/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var cities = [City](){
        didSet{
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()

    }
    private func setupHome(){
        cities = CityManager.load()
        historyTableView.tableFooterView = UIView(frame: .zero)
    }
    
    

}
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        let city = cities[indexPath.row]
        cell.mainLabel.text = "\(city.name), \(city.state)"
        cell.subLabel.text = "Population: \(city.population)"
        
        return cell
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
       // let city = cities[indexPath.row]
        let city = cities[0]

        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.city = city
        
        
        navigationController?.view.backgroundColor = .blue
        navigationController?.pushViewController(mapVC, animated: true)
        
    }
}
