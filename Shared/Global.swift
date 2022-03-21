import Archivable
import CloudKit
import Secrets

let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.beet")
let store = Store()
