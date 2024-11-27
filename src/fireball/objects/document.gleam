//Firestore document type
pub type FireballDocument {
  // "data" is the fields section of a document
  FireballDocument(data: String, creation_time: String)
}

//Function to transform a document into a semi-colon string
pub fn doc_to_string(doc doc: FireballDocument) -> String {
  doc.data <> ";" <> doc.creation_time
}

//Function to transform a document into a list of strings
pub fn doc_to_list(doc doc: FireballDocument) -> List(String) {
  [doc.data, doc.creation_time]
}

//Function to transform a document into a tuple of strings
pub fn doc_to_tuple(doc doc: FireballDocument) -> #(String, String) {
  #(doc.data, doc.creation_time)
}
