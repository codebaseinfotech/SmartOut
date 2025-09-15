//
//  PieChart.swift
//  ChartDemo
//
//  Created by Ankit Gabani on 15/09/25.
//

import Foundation
import DGCharts
import UIKit


class PieChart {
    
    static var shared = PieChart()
    
    func setupChart(view: UIView, entries: [PieChartDataEntry], colors: [UIColor]) {
        let pieChart = PieChartView()
        
        view.addSubview(pieChart)
        view.isUserInteractionEnabled = false
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pieChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pieChart.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Example values (3 segments like your screenshot)
        let entries = entries
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = colors
        dataSet.valueTextColor = .white
        dataSet.valueFont = .systemFont(ofSize: 14, weight: .bold)
        dataSet.drawValuesEnabled = true
        
        // Format values as percentages with % sign
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChart.data = data
        
        // Chart settings
        pieChart.drawEntryLabelsEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        pieChart.holeColor = .white
        pieChart.holeRadiusPercent = 0.0  // solid pie (no donut)
        pieChart.transparentCircleRadiusPercent = 0.0
    }
    
}
