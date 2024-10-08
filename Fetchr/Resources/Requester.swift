//
//  Requester.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/21/24.
//

import Foundation

class Requester {
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "RESTRequester-Downloader")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    init() {
    }
    
    func convertHeaderDataToDictionary(headerData:HeaderData) -> Dictionary<String,String> {
        var toReturn = [String:String]()
        for row in headerData.headerRows {
            toReturn.updateValue(row.value, forKey: row.key)
        }
        return toReturn
    }
    
    func makeRequest(url:String = "", method:RequesterMethod = .GET, headers:Dictionary<String, String>, body:String, completionHandler: @escaping (String?,Error?) -> Void) {
        //Build URL
        guard let url = URL(string: url) else { return }
        //Build HTTP Request (including url, method, headers, and body values)
        var request = URLRequest(url: url)
        request.httpMethod = "\(method.rawValue)"
        for(key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if body.count > 0 {
            request.httpBody = body.data(using: .utf8)
        }
        
        //Complete the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard err == nil else {
                completionHandler(nil, err)
                return
            }
            if !url.absoluteString.contains("https://gdmf.apple.com") && !url.absoluteString.contains("https://mesu.apple.com") {
                completionHandler(String(data: data!, encoding: .utf8)!, nil)
            } else {
                //If this reaches Pallas
                if let resp = data {
                    let respStr = String(data: resp, encoding: .utf8)!
                    let trimmed = respStr.split(separator: ".")[1]
                    var decodedString = ""
                    if let converted = Data(base64Encoded: String(trimmed) + "==") { //TODO: Calculate this so we switch this to a toggle later
                        decodedString = String(data: converted, encoding: .utf8)!
                    }
                    completionHandler(decodedString, nil) //Return decoded string for view to handle
                }
            }
        }
        task.resume()
    }
    
    func fileToUrl(filePath:String="/tmp/temporarylFile.temp") -> URL? {
        var fileURL:URL?
        if filePath.count == 0 {
            do {
                let downloadsPath = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true).absoluteString
                //            let filePath = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true).absoluteString + "\(url.components(separatedBy: "/").last!)"
                let filePath = downloadsPath + "\(filePath.components(separatedBy: "/").last!)"
                fileURL = URL(string: filePath)
            } catch {
                print("Error thrown and not handled [Requester.Swift]:L51")
                return nil
            }
        } else {
            fileURL = URL(fileURLWithPath: filePath)
        }
        return fileURL!
    }
    
    func downloadForeground(url:String="", toFile:String="") -> Bool {
        let fileURL:URL = fileToUrl(filePath: url)!
        let downloadTask = URLSession.shared.downloadTask(with: fileURL) {
            urlOrNil, responseOrNil, errorOrNil in
            
            guard errorOrNil == nil else {
                print("Error when downloading file \(String(describing: errorOrNil))")
                return
            }
            
            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try FileManager.default.url(for: .downloadsDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: true)
//                let savedURL = documentsURL.appendingPathComonent(fileURL.lastPathComponent)
                let savedURL:URL = URL(fileURLWithPath: documentsURL.absoluteString + fileURL.lastPathComponent)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
            } catch {
                print("File error: \(error)")
                return
            }
        }
        downloadTask.resume()
        return true
    }
    
    func downloadBackground(url:String="", toFile:String="", earliestBeginDate:Date=Date().addingTimeInterval(3600)) {
        let fileURL = fileToUrl(filePath: toFile)
        let backgroundTask = urlSession.downloadTask(with: URL(string: url)!)
        backgroundTask.earliestBeginDate = earliestBeginDate
        backgroundTask.countOfBytesClientExpectsToSend = 200
        
        // Can I calculate this somehow? Or pull this from a Header somehow?
        backgroundTask.countOfBytesClientExpectsToReceive = 500 * 1024
    }
    
    func saveToFile(data:Data, fileLocation:String) throws {
        do {
            let documentURL = URL(fileURLWithPath: fileLocation)
            if FileManager.default.fileExists(atPath: documentURL.path) {
                try FileManager.default.removeItem(at: documentURL)
            }
            try data.write(to: documentURL)
        } catch {
            throw RequesterErrors.unableToSaveFile("Unable to write file to disk. Please confirm that the system has disk write access")
        }
    }
}
