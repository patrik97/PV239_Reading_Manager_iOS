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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var entries = [PieChartDataEntry]()
        
        LocalStorageManager.shared.loadAllBooks(completion: { (libBooks, wishBooks) in
            var allBooks = libBooks + wishBooks
            
            let notOwnedBooks = allBooks.filter{ $0.state == BookState.notOwned }
            let readedBooks = allBooks.filter{ $0.state == BookState.readed }
            let readingBooks = allBooks.filter{ $0.state == BookState.reading }
            let unreadBooks = allBooks.filter{ $0.state == BookState.unread }
            
            entries = appendList(books: notOwnedBooks, label: "Wished Books", entries: entries)
            entries = appendList(books: readedBooks, label: "Already read Books", entries: entries)
            entries = appendList(books: unreadBooks, label: "Unreaded Books", entries: entries)
            entries = appendList(books: readingBooks, label: "Currently reading Books", entries: entries)
            
            let set = PieChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.joyful()
            
            let data = PieChartData(dataSet: set)
            pieChart.data = data
        })
    }
    
    private func appendList(books: [Book], label: String, entries: [PieChartDataEntry]) -> [PieChartDataEntry] {
        var newEntries = entries
        if books.count > 0 {
            newEntries.append(PieChartDataEntry(value: Double(books.count), label: label))
        }
        return newEntries
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
