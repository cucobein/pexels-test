//
//  VideoObject.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation
import RealmSwift

class VideoObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var userName: String = ""
    @objc dynamic var userUrl: String = ""

    let videoFiles = List<VideoFileObject>()
    let videoPictures = List<VideoPictureObject>()

    override static func primaryKey() -> String? {
        "id"
    }
}

class VideoFileObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var quality: String = ""
    @objc dynamic var fileType: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var link: String = ""
}

// swiftlint:disable identifier_name
class VideoPictureObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var picture: String = ""
    @objc dynamic var nr: Int = 0
}
