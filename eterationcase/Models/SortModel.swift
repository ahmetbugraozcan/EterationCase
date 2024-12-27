//
//  SortModel.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

enum SortModel {
    case date(_ sortType: SortType)
    case price(_ sortType: SortType)
    
    func getPath() -> String {
        switch self {
        case .date:
            "createdAt"
        case .price:
            "price"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .date(let sortType):
            switch sortType {
            case .desc:
                "New to old"
            case .asc:
                "Old to new"
            }
        case .price(let sortType):
            switch sortType {
            case .desc:
                "Price high to low"
            case .asc:
                "Price low to High"
            }
        }
    }
}

extension SortModel {
    func getSortType() -> SortType {
        switch self {
        case .date(let sortType), .price(let sortType):
            return sortType
        }
    }
}

enum SortType: String {
    case desc
    case asc
}
