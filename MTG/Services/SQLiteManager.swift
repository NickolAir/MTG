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
    private func openDatabase() {
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
    
    private func createCardsTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Cards (
        Id INTEGER PRIMARY KEY, 
        Name TEXT,
        ImageUrl TEXT);
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Cards table successfully created or opened")
        }
        else {
            print("Error of creating or opening cards table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    func getCard(id: Int) -> CardModel? {
        var queryStatement: OpaquePointer?
        let query = "SELECT Id, Name, Age FROM Cards WHERE Id = \(id);"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            let id = sqlite3_column_int(queryStatement, 0)
            let name = String(cString: sqlite3_column_text(queryStatement, 1))
            let imageUrl = String(cString: sqlite3_column_text(queryStatement, 2))
            return CardModel(id: Int(id), imageUrl: imageUrl, cardName: name)
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func getImagePath(id: Int) -> String? {
        var queryStatement: OpaquePointer?
        let query = "SELECT ImageUrl FROM Cards WHERE Id = \(id);"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            let imageUrl = String(cString: sqlite3_column_text(queryStatement, 1))
            return imageUrl
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func getAllCards() -> [CardModel] {
        var queryStatement: OpaquePointer?
        let query = "SELECT * FROM Cards;"
        
        var cards: [CardModel] = []
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let imageUrl = String(cString: sqlite3_column_text(queryStatement, 2))
                cards.append(CardModel(id: Int(id), imageUrl: imageUrl, cardName: name))
            }
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(queryStatement)
        return cards
    }
    
    private func getMaxId() -> Int? {
        let query = "SELECT MAX(Id) FROM Users;"
        var queryStatement: OpaquePointer?
        var maxId: Int?

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                maxId = Int(sqlite3_column_int(queryStatement, 0)) // Чтение результата (максимальный Id)
            }
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }

        sqlite3_finalize(queryStatement)
        return maxId
    }
    
    func insertCard(id: Int, name: String, imageUrl: String) -> Bool {
        let query = "INSERT INTO Cards (Id, Name, imageUrl) VALUES (\(id), \(name), \(imageUrl)) ;"
        var queryStatement: OpaquePointer?

        // Подготовка запроса
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            // Выполнение запроса
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Запись успешно добавлена.")
                sqlite3_finalize(queryStatement)
                return true
            } else {
                print("Ошибка при добавлении записи: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Ошибка подготовки INSERT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(queryStatement)
        return false
    }
    
    func insertCards(cards: [CardModel]) {
        for card in cards {
            insertCard(id: card.id, name: card.cardName, imageUrl: card.imageUrl)
        }
    }
}
