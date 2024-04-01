//
//  SecurityImageService.swift
//  InvestTrack
//
//  Created by Соня on 09.03.2024.
//

//import Foundation
//import SwiftUI
//import Combine
//
//class SecurityImageService {
//    
//    @Published var image: UIImage? = nil
//    
//    private var imageSubscription: AnyCancellable?
//    private let security: SecurityModel
//    private let fileManager = LocalFileManager.instance
//    private let folderName = "security_images"
//    private let imageName: String
//    
//    init(security: SecurityModel) {
//        self.security = security
//        self.imageName = security.id
//        getSecurityImage()
//        
//    }
//    
//    private func getSecurityImage() {
//        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
//            image = savedImage
//        } else {
//            downloadSecurityImage()
//        }
//    }
//    
//    private func downloadSecurityImage() {
//        guard let url = URL(string: security.image) else { return }
//        
//        imageSubscription = NetworkingManager.download(url: url)
//            .tryMap({ (data) -> UIImage? in
//                return UIImage(data: data)
//            })
//            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
//                guard let self = self, let downloadedImage = returnedImage else { return }
//                self.image = downloadedImage
//                self.imageSubscription?.cancel()
//                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
//            })
//    }
//}
