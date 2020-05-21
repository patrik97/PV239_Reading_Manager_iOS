//
//  StatisticsController.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Lukáš Matta on 21/05/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit
import Charts

class StatisticsController: UIViewController, ChartViewDelegate {
    var wishedBooks: [Book] = []
    var libraryBooks: [Book] = []
    
    var pieChart = PieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        var entries = [PieChartDataEntry]()
        
        LocalStorageManager.shared.getAllBooks(completion: { (libBooks, wishBooks) in
            self.libraryBooks = libBooks
            self.wishedBooks = wishBooks
            
            entries.append(PieChartDataEntry(value: Double(libraryBooks.count), label: "Owned books"))
            entries.append(PieChartDataEntry(value: Double(wishedBooks.count), label: "Wished books"))
            
            let set = PieChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.joyful()
            
            let data = PieChartData(dataSet: set)
            pieChart.data = data
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
