//
//  SQLiteManager.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//
import SQLite3
import Foundation

class SQLiteManager: DataBaseManager {
    private var db: OpaquePointer?
    init() {
        openDatabase()
    }
    
    // Открыть или создать базу данных
    func openDatabase() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("MTGDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Успешное подключение к базе данных")
        } else {
            print("Не удалось открыть базу данных")
        }
    }
    
    func createCardsTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Cards (
        Id INTEGER PRIMARY KEY, 
        Name TEXT,
        ImagePath TEXT);
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Cards table successfully created or opened")
        }
        else {
            print("Error of creating or opening cards table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    func getCard(id: Int) -> CardModel {
        // TODO: Implement getCard
        return CardModel(id: 0, imagePath: "", cardName: "")
    }
    
    func getImagePath(for cardId: Int) -> String {
        // TODO: Implement getImagePath
        return ""
    }
    
    func getAllCards() -> [CardModel] {
        // TODO: Implement getAllCards
        return []
    }
    
    
}
