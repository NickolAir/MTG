//
//  SQLiteManager.swift
//  MTG
//
//  Created by Леонид Шайхутдинов on 07.12.2024.
//
import SQLite3
import Foundation
import Combine

class SQLiteManager: DataBaseManager {
    private var dbFilePath: URL?
    
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
            dbFilePath = fileURL
            sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
            createTables()
        } else {
            print("Не удалось открыть базу данных")
        }
    }
    
    private func createTables() {
        // Создаём таблицу Pictures
        let createPicturesTableQuery = """
        CREATE TABLE IF NOT EXISTS Pictures (
        Id INTEGER PRIMARY KEY, 
        Url TEXT NOT NULL);
        """
        
        if sqlite3_exec(db, createPicturesTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Pictures table successfully created or opened")
        } else {
            print("Error of creating or opening Pictures table: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        // Создаём таблицу Cards с внешним ключом PictureID
        let createCardsTableQuery = """
        CREATE TABLE IF NOT EXISTS Cards (
        Id INTEGER PRIMARY KEY, 
        Name TEXT NOT NULL,
        PictureID INTEGER,
        FOREIGN KEY (PictureID) REFERENCES Pictures(Id) ON DELETE CASCADE);
        """
        
        if sqlite3_exec(db, createCardsTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Cards table successfully created or opened")
        } else {
            print("Error of creating or opening Cards table: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        // Создаем таблицу для связанных карт
        let createRelationsTableQuery = """
        CREATE TABLE IF NOT EXISTS CardRelations (
        Id INTEGER PRIMARY KEY,
        CardID INTEGER NOT NULL,
        RelatedCardID INTEGER NOT NULL,
        FOREIGN KEY (CardID) REFERENCES Cards(Id) ON DELETE CASCADE,
        FOREIGN KEY (RelatedCardID) REFERENCES Cards(Id) ON DELETE CASCADE);
        """
        
        if sqlite3_exec(db, createRelationsTableQuery, nil, nil, nil) == SQLITE_OK {
            print("CardRelations table successfully created or opened")
        } else {
            print("Error creating or opening CardRelations table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    func getCard(id: Int) -> CardModel? {
        var queryStatement: OpaquePointer?
        let query = "SELECT Id, Name, Age FROM Cards WHERE Id = \(id);"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            let id = sqlite3_column_int(queryStatement, 0)
            let name = String(cString: sqlite3_column_text(queryStatement, 1))
            let imageUrl = String(cString: sqlite3_column_text(queryStatement, 2))
            return CardModel(id: Int(id), name: name, picture: CardModel.Picture(id: Int(id), url: imageUrl))
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        return nil
    }
    
    func getImageUrl(id: Int) -> String? {
        var queryStatement: OpaquePointer?
        let query = "SELECT Url FROM Pictures WHERE Id = ?;"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            // Привязываем ID к параметру
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            
            // Выполняем запрос и проверяем, есть ли строка
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                if let cString = sqlite3_column_text(queryStatement, 0) {
                    let imageUrl = String(cString: cString)
                    sqlite3_finalize(queryStatement) // Освобождение ресурсов
                    return imageUrl
                }
            } else {
                print("Запись с Id = \(id) не найдена.")
            }
        } else {
            print("Ошибка подготовки SELECT запроса: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(queryStatement) // Освобождение ресурсов
        return nil
    }
    
    func printAllCards() {
        let query = "SELECT * FROM Cards;"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            print("Результаты запроса SELECT * FROM Cards:")
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                // Получение ID карты
                let id = sqlite3_column_int(queryStatement, 0)
                
                // Получение имени карты
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                
                // Получение PictureID (может быть NULL)
                var pictureID: Int? = nil
                if sqlite3_column_type(queryStatement, 2) != SQLITE_NULL {
                    pictureID = Int(sqlite3_column_int(queryStatement, 2))
                }
                
                // Печать строки в консоль
                print("ID: \(id), Name: \(name), PictureID: \(pictureID ?? -1)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Ошибка выполнения SELECT запроса: \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
    }
    
    func getAllCards() -> AnyPublisher<[CardModel], Error> {
        Deferred {
            Future<[CardModel], Error> { promise in
                var queryStatement: OpaquePointer?
                let query = """
                SELECT c.Id, c.Name, p.Url
                FROM Cards c
                LEFT JOIN Pictures p ON c.PictureID = p.Id;
                """
                
                var cards: [CardModel] = []
                
                DispatchQueue.global(qos: .background).async {
                    if sqlite3_prepare_v2(self.db, query, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                            let cardId = sqlite3_column_int(queryStatement, 0)
                            let cardName = String(cString: sqlite3_column_text(queryStatement, 1))
                            
                            var imageUrl: String? = nil
                            if let urlPointer = sqlite3_column_text(queryStatement, 2) {
                                imageUrl = String(cString: urlPointer)
                            }
                            
                            let picture = CardModel.Picture(id: Int(cardId), url: imageUrl ?? "")
                            let card = CardModel(id: Int(cardId), name: cardName, picture: picture)
                            cards.append(card)
                        }
                        
                        sqlite3_finalize(queryStatement)
                        DispatchQueue.main.async {
                            promise(.success(cards))
                        }
                    } else {
                        let errorMessage = String(cString: sqlite3_errmsg(self.db))
                        DispatchQueue.main.async {
                            promise(.failure(NSError(
                                domain: "DatabaseError",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Ошибка подготовки SELECT запроса: \(errorMessage)"]
                            )))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
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
    
    func insertPicture(id: Int, url: String) -> Bool {
        
        let formatedUrl = "'\(url)'"
        let query = "INSERT INTO Pictures (Id, Url) VALUES (?, \(formatedUrl)) ;"
        var queryStatement: OpaquePointer?
        
        // Подготовка запроса
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            //sqlite3_bind_text(queryStatement, 2, url, -1, nil)
            
            // Выполнение запроса
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Изображение \(id) успешно добавлено в базу данных.")
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
    
    func insertCard(id: Int, name: String, picture: CardModel.Picture) -> Bool {
        guard let id = picture.id, let pictureUrl = picture.url else {
            return false
        }
        
        let pictureInsertResult = insertPicture(id: id, url: pictureUrl)
        
        
        var queryStatement: OpaquePointer?
        
        let formatedName = "'\(name)'"
        
        let query = "INSERT INTO Cards (Id, Name, PictureID) VALUES (?, \(formatedName), ?) ;"

        // Подготовка запроса
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            //sqlite3_bind_text(queryStatement, 2, formatedName, -1, nil)
            sqlite3_bind_int(queryStatement, 2, Int32(picture.id!))
            // Выполнение запроса
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Карта \(id) успешно добавлена в базу данных.")
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
            insertCard(id: card.id!, name: card.name!, picture: card.picture)
        }
    }
    
    func deleteAllData() {
        // Отключаем проверки внешних ключей, чтобы избежать ошибок при удалении
        let disableForeignKeyQuery = "PRAGMA foreign_keys = OFF;"
        
        // Подготовка запроса на удаление данных
        let deleteCardsQuery = "DELETE FROM Cards;"
        let deletePicturesQuery = "DELETE FROM Pictures;"
        let deleteRelationsQuery = "DELETE FROM CardRelations;"

        // Открытие базы данных
        var db: OpaquePointer?
        guard let dbFilePath = dbFilePath else {
            return
        }
        
        if sqlite3_open(dbFilePath.path, &db) != SQLITE_OK {
            print("Не удалось открыть базу данных.")
            return
        }
        
        // Отключаем проверки внешних ключей перед выполнением удаления
        if sqlite3_exec(db, disableForeignKeyQuery, nil, nil, nil) != SQLITE_OK {
            print("Не удалось отключить внешние ключи: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        
        // Удаляем данные из таблиц
        let queries = [deleteCardsQuery, deletePicturesQuery, deleteRelationsQuery]
        
        for query in queries {
            if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
                print("Ошибка при удалении данных: \(String(cString: sqlite3_errmsg(db)))")
            } else {
                print("Данные успешно удалены из таблицы.")
            }
        }
        
        // Включаем проверки внешних ключей обратно
        let enableForeignKeyQuery = "PRAGMA foreign_keys = ON;"
        if sqlite3_exec(db, enableForeignKeyQuery, nil, nil, nil) != SQLITE_OK {
            print("Не удалось включить внешние ключи: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        // Закрытие базы данных
        sqlite3_close(db)
    }
}
