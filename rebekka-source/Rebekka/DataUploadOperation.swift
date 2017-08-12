//
//  DataUploadOperation.swift
//  Rebekka
//
//  Created by Olson, Tim (Area 51) on 7/25/17.
//  Copyright © 2017 Constantine Fry. All rights reserved.
//

import Foundation

/** Operation for data uploading. */
internal class DataUploadOperation: WriteStreamOperation {
    var data: Data!
    
    override func start() {
        self.startOperationWithStream(self.writeStream)
    }
    
    override func streamEventEnd(_ aStream: Stream) -> (Bool, NSError?) {
        return (true, nil)
    }
    
    override func streamEventError(_ aStream: Stream) {
        super.streamEventError(aStream)
    }
    
    override func streamEventHasSpace(_ aStream: Stream) -> (Bool, NSError?) {
        if let writeStream = aStream as? OutputStream {
            let length = min(self.data.count, 1024)
            let chunk = self.data.subdata(in: 0..<length)
            let buffer = (chunk as NSData).bytes.bindMemory(to: UInt8.self, capacity: chunk.count)
            let writtenBytes = writeStream.write(buffer, maxLength: chunk.count)
            if writtenBytes == self.data.count {
                self.finishOperation()
            } else if writtenBytes > 0 {
                self.data = self.data.advanced(by: writtenBytes)
            } else if writtenBytes == -1 {
                self.finishOperation()
            }
        }
        return (true, nil)
    }
    
}

