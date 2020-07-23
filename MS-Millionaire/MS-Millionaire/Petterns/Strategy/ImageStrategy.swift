//
//  ImageStrategy.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 29.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

protocol ImageToDataConvertingStrategy​ {
    func data(from image: UIImage) -> Data?
}

class ImageToPNGDataConverter​: ImageToDataConvertingStrategy​ {
    func data(from image: UIImage) -> Data? {
        return image.pngData()
    }
}
class ImageToJPEGDataConverter​: ImageToDataConvertingStrategy​ {
    func data(from image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.95)
    }
}
class ImageToJPEGLowQualityDataConverter​: ImageToDataConvertingStrategy​ {
    func data(from image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0)
    }
}
