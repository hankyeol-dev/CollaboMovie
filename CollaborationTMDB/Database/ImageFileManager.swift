//
//  ImageFileManager.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import UIKit.UIImage

enum SavePhotoError: Error {
    case save
}

enum ImageFileManager {
    static func removeImage(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
    }
    
    static func loadImage(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "photo")
        }
    }
    
    static func addImage(
        urlString: String,
        filename: String,
        completionHandler: @escaping (Result<String, SavePhotoError>) -> Void
    ) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                ImageFileManager.saveImage(image: image, filename: filename)
                completionHandler(.success(filename))
            } else {
                completionHandler(.failure(.save))
            }
        }
    }
    
    private static func saveImage(image: UIImage, filename: String) {
        // Document의 파일 위치를 찾음
        // 찾지 못할 경우 파일 저장 불가
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        // 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
}
