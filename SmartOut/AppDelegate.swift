//
//  AppDelegate.swift
//  SmartOut
//
//  Created by iMac on 12/09/25.
//

import UIKit
import LGSideMenuController
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dicAllData = AllData()
    
    static var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    var arrAllData: [[String: Any]] = [[:]]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let path = Bundle.main.path(forResource: "smartout", ofType: "sqlite") {
            fetchAllData(from: path)
        }
        
        let animals = loadHunterReportingData()
        arrAllData = animals

        
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        homeNavigation.navigationBar.isHidden = true

        // SideBarVC from XIB
        let leftMenuVC = SideMenuVC(nibName: "SideMenuVC", bundle: nil)

        // LGSideMenuController setup
        let sideMenuController = LGSideMenuController(rootViewController: homeNavigation,
                                                      leftViewController: leftMenuVC,
                                                      rightViewController: nil)

        // Adjust menu width
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width - 70
        sideMenuController.navigationController?.navigationBar.isHidden = true
        // Set as root
        window?.rootViewController = sideMenuController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func loadHunterReportingData() -> [[String: Any]] {
        guard let url = Bundle.main.url(forResource: "HunterReportingData", withExtension: "json") else {
            print("❌ JSON file not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let dataArray = json["data"] as? [[String: Any]] {
                return dataArray
            }
        } catch {
            print("❌ Error parsing JSON:", error)
        }
        return []
    }
    
    func fetchAllData(from dbPath: String) {
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            // Helper function to fetch and decode table rows into [T]
            func fetchTable<T: Decodable>(tableName: String, as type: T.Type) -> [T] {
                var result: [T] = []
                let query = "SELECT * FROM \(tableName);"
                var stmt: OpaquePointer?
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                    let columnCount = sqlite3_column_count(stmt)
                    var columnNames: [String] = []
                    for i in 0..<columnCount {
                        if let name = sqlite3_column_name(stmt, Int32(i)) {
                            columnNames.append(String(cString: name))
                        } else {
                            columnNames.append("col\(i)")
                        }
                    }
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var dict: [String: Any] = [:]
                        for i in 0..<columnCount {
                            let colType = sqlite3_column_type(stmt, i)
                            let key = columnNames[Int(i)]
                            switch colType {
                            case SQLITE_INTEGER:
                                dict[key] = Int(sqlite3_column_int64(stmt, i))
                            case SQLITE_FLOAT:
                                dict[key] = sqlite3_column_double(stmt, i)
                            case SQLITE_TEXT:
                                if let cstr = sqlite3_column_text(stmt, i) {
                                    dict[key] = String(cString: cstr)
                                } else {
                                    dict[key] = nil
                                }
                            case SQLITE_NULL:
                                dict[key] = nil
                            default:
                                dict[key] = nil
                            }
                        }
                        // Convert dict to JSON, then decode to T
                        do {
                            let json = try JSONSerialization.data(withJSONObject: dict, options: [])
                            let obj = try JSONDecoder().decode(T.self, from: json)
                            result.append(obj)
                        } catch {
                            // Could log decoding error for this row
                        }
                    }
                }
                sqlite3_finalize(stmt)
                return result
            }
            
            // Load all tables into arrays
            let fish = fetchTable(tableName: "fish", as: Fish.self)
            let fishing_exception_types = fetchTable(tableName: "fishing_exception_types", as: FishingExceptionType.self)
            let fmz = fetchTable(tableName: "fmz", as: FMZ.self)
            let wmu_geometry = fetchTable(tableName: "wmu_geometry", as: WMUGeometry.self)
            let fmz_geometry = fetchTable(tableName: "fmz_geometry", as: FMZGeometry.self)
            let wmu = fetchTable(tableName: "wmu", as: WMU.self)
            let fishing_general_info = fetchTable(tableName: "fishing_general_info", as: FishingGeneralInfo.self)
            let fishing_seasons = fetchTable(tableName: "fishing_seasons", as: FishingSeason.self)
            let hunting_seasons = fetchTable(tableName: "hunting_seasons", as: HuntingSeason.self)
            let hunting_season_wmus = fetchTable(tableName: "hunting_season_wmus", as: HuntingSeasonWMU.self)
            let deer_controlled = fetchTable(tableName: "deer_controlled", as: DeerControlled.self)
            let deer_antlerless = fetchTable(tableName: "deer_antlerless", as: DeerAntlerless.self)
            let moose_draw_types = fetchTable(tableName: "moose_draw_types", as: MooseDrawType.self)
            let moose_draw = fetchTable(tableName: "moose_draw", as: MooseDraw.self)
            let animals = fetchTable(tableName: "animals", as: Animal.self)
            let list_municipal = fetchTable(tableName: "list_municipal", as: Municipality.self)
            let municipality_geometry = fetchTable(tableName: "municipality_geometry", as: MunicipalityGeometry.self)
            let pin_coordinate = fetchTable(tableName: "pin_coordinate", as: PinCoordinate.self)
            let exceptions = fetchTable(tableName: "exceptions", as: ExceptionModel.self)
            let hunter_report_statistic = fetchTable(tableName: "hunter_report_statistic", as: HunterReportStatistic.self)
            let hunter_report_harvest = fetchTable(tableName: "hunter_report_harvest", as: HunterReportHarvest.self)
            
            let allData = AllData(
                fish: fish,
                fishing_exception_types: fishing_exception_types,
                fmz: fmz,
                wmu_geometry: wmu_geometry,
                fmz_geometry: fmz_geometry,
                wmu: wmu,
                fishing_general_info: fishing_general_info,
                fishing_seasons: fishing_seasons,
                hunting_seasons: hunting_seasons,
                hunting_season_wmus: hunting_season_wmus,
                deer_controlled: deer_controlled,
                deer_antlerless: deer_antlerless,
                moose_draw_types: moose_draw_types,
                moose_draw: moose_draw,
                animals: animals,
                list_municipal: list_municipal,
                municipality_geometry: municipality_geometry,
                pin_coordinate: pin_coordinate,
                exceptions: exceptions,
                hunter_report_statistic: hunter_report_statistic,
                hunter_report_harvest: hunter_report_harvest
            )
            // Print as JSON to confirm
            //            do {
            //                let jsonData = try JSONEncoder().encode(allData)
            //                if let jsonString = String(data: jsonData, encoding: .utf8) {
            //                    print("jsonString:- \(jsonString)")
            //                }
            //            } catch {
            //                print("❌ Failed to encode AllData to JSON: \(error)")
            //            }
            
            print("jsonString:- \(allData.exceptions.count)")
            self.dicAllData = allData
            sqlite3_close(db)
        } else {
            print("❌ Failed to open database")
        }
    }


}

