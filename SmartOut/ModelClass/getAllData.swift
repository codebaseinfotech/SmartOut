//
//  getAllData.swift
//  SmartOut
//
//  Created by Ankit Gabani on 17/09/25.
//

import Foundation

struct MetricGroup {
    let title: String
    let data: [(year: String, value: Double)]
}

struct AllData: Codable {
    var fish: [Fish] = []
    var fishing_exception_types: [FishingExceptionType] = []
    var fmz: [FMZ] = []
    var wmu_geometry: [WMUGeometry] = []
    var fmz_geometry: [FMZGeometry] = []
    var wmu: [WMU] = []
    var fishing_general_info: [FishingGeneralInfo] = []
    var fishing_seasons: [FishingSeason] = []
    var hunting_seasons: [HuntingSeason] = []
    var hunting_season_wmus: [HuntingSeasonWMU] = []
    var deer_controlled: [DeerControlled] = []
    var deer_antlerless: [DeerAntlerless] = []
    var moose_draw_types: [MooseDrawType] = []
    var moose_draw: [MooseDraw] = []
    var animals: [Animal] = []
    var list_municipal: [Municipality] = []
    var municipality_geometry: [MunicipalityGeometry] = []
    var pin_coordinate: [PinCoordinate] = []
    var exceptions: [ExceptionModel] = []
    var hunter_report_statistic: [HunterReportStatistic] = []
    var hunter_report_harvest: [HunterReportHarvest] = []
}

// MARK: - Fish
struct Fish: Codable {
    let id: Int?
    let name: String?
    let imagePath: String?
    let text: String?
    let pinImage: String?
    let bubbleImage: String?
    let wmuId: Int?
    let geometry: String?
    let fmzId: Int?
    let parentId: Int?
}

// MARK: - FMZ
struct FMZ: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - WMU
struct WMU: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - Animals
struct Animal: Codable {
    let id: Int?
    let name: String?
    let list_priority: Int?
    let image_path: String?
}

// MARK: - Fishing Seasons
struct FishingSeason: Codable {
    let id: Int?
    let fish_id: Int?
    let fmz_id: Int?
    let season: String?
    let limits_resident: String?
    let limits_non_resident: String?
}

// MARK: - Hunting Seasons
struct HuntingSeason: Codable {
    let id: Int?
    let animalId: Int?
    let startDate: String?
    let endDate: String?
    let limit: String?
}

// MARK: - Moose Draw
struct MooseDraw: Codable {
    let id: Int?
    let typeId: Int?
    let description: String?
}

// MARK: - Municipality
struct Municipality: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - Pin Coordinates
struct PinCoordinate: Codable {
    let id: Int?
    let latitude: Double?
    let longitude: Double?
}

// MARK: - Exception
struct Exception: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Hunter Report
struct HunterReport: Codable {
    let id: Int?
    let year: Int?
    let harvest: Int?
    let successRate: Double?
}

// MARK: - Fishing Exception Type
struct FishingExceptionType: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - WMU Geometry
struct WMUGeometry: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - FMZ Geometry
struct FMZGeometry: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - Fishing General Info
struct FishingGeneralInfo: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Hunting Season WMU
struct HuntingSeasonWMU: Codable {
    let id: Int?
    let name: String?
    let wmuId: Int?
}

// MARK: - Deer Controlled
struct DeerControlled: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Deer Antlerless
struct DeerAntlerless: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Moose Draw Type
struct MooseDrawType: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Municipality Geometry
struct MunicipalityGeometry: Codable {
    let id: Int?
    let name: String?
    let geometry: String?
}

// MARK: - Exception Model
struct ExceptionModel: Codable {
    let id: Int?
    let name: String?
    let description: String?
}

// MARK: - Hunter Report Statistic
struct HunterReportStatistic: Codable {
    let id: Int?
    let animal_id: Int?
    let metric_name: String?
    let year: String?
    let metric_in_percent: Double?
    let metric_in_number: String?
}

// MARK: - Hunter Report Harvest
struct HunterReportHarvest: Codable {
    let id: Int?
    let animal_id: Int?
    let title: String?
    let label: String?
    let value_in_percent: Int?
}
