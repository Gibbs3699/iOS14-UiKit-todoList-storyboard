//
//  DatabaseManager.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 31/8/2565 BE.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class DatabaseManager {
    
    private let db = Firestore.firestore()
    
    private lazy var taskCollection = db.collection("tasks")
    private var listener: ListenerRegistration?
    
    func addTask(task: Task, completion: @escaping (Result<Void,Error>) -> Void) {
        do {
            _ = try taskCollection.addDocument(from: task, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                }else {
                    completion(.success(()))
                }
            })
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func addTaskListener(forDoneTasks isDone: Bool, completion: @escaping (Result<[Task],Error>) -> Void) {
        
        listener = taskCollection
            .whereField("isDone", isEqualTo: isDone)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener({ (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var tasks = [Task]()
                do {
                    tasks = try snapshot?.documents.compactMap({
                        return try $0.data(as: Task.self)
                    }) ?? []
                } catch(let error) {
                    completion(.failure(error))
                }
                completion(.success(tasks))
            }
        })
    }
    
    func updateTaskStatus(id: String, isDone: Bool, completion : @escaping (Result<Void,Error>) -> Void) {
        
        var fields: [String : Any] = [:]
        
        if isDone {
            fields = ["isDone": true, "doneAt": Date()]
        } else {
            fields = ["isDone": false, "doneAt": FieldValue.delete()]
        }
        
        taskCollection.document(id).updateData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
