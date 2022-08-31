//
//  DatabaseManager.swift
//  Todo List Storyboard Version
//
//  Created by TheGIZzz on 31/8/2565 BE.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
    func addTaskListener(completion: @escaping (Result<[Task],Error>) -> Void) {
        
        listener = taskCollection.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                
                let tempTasks = try? snapshot?.documents.compactMap({
                    return try $0.data(as: Task.self)
                })
                
                let tasks = tempTasks ?? []
                
                completion(.success(tasks))
            }
        })
    }
}
