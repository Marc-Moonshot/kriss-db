// import admin.json
// get all collection names
// create folders for each collection
// for collection in collections
// get documents in collection
// save document in export_data/collection/documentID

import admin from "firebase-admin"
import { QueryDocumentSnapshot } from "firebase-admin/firestore"
import fs from "fs"
import path from "path"

const serviceAccountPath = path.resolve(__dirname, "secrets", "admin.json")

if (!fs.existsSync(serviceAccountPath)) {
  console.error("admin.json not found.")
  process.exit(1)
}

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccountPath)
})

const db = admin.firestore()
const exportBase = path.resolve(__dirname, "export_data")

async function exportCollection(collectionPath: string, basePath: string) {
  const collectionRef = db.collection(collectionPath)
  console.log("collection ID: ", collectionRef.id)

  const collectionDir = path.join(basePath, collectionPath)
  fs.mkdirSync(collectionDir, { recursive: true })

  console.log("created ", collectionDir)

  let count = 0
  const stream = collectionRef.stream() as AsyncIterable<QueryDocumentSnapshot>

  const writes: Promise<any>[] = []

  for await (const doc of stream) {
    const docPath = path.join(collectionDir, `${doc.id}.json`)
    writes.push(fs.promises.writeFile(docPath, JSON.stringify(doc.data())))

    if (writes.length >= 100) {
      count += writes.length
      await Promise.all(writes)
      writes.length = 0
      console.log(`saved ${count} documents.`)
    }
  }

  if (writes.length) {
    count += writes.length
    await Promise.all(writes)
  }
  console.log(`Finished exporting ${count} documents from ${collectionPath}`)
}

async function main() {
  console.time("export")

  fs.mkdirSync(exportBase, { recursive: true })
  console.log("created export_data dir successfully.")
  await exportCollection("device_data", exportBase)
  console.log("Export complete.")

  console.timeEnd("export")
  process.exit(0)
}

main().catch((err) => {
  console.error("Error exporting Firestore:", err)
  process.exit(1)
})
