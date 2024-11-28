//gleam
import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/json.{object, string}

//decode
import decode/zero as decode

//
pub type FireballStorage {
  FireballStorage(path: String)
}

//A type representing the JSON returning when uploading an object to Google Firebase Storage
pub type UploadData {
  UploadData(
    name: String,
    bucket: String,
    generation: String,
    metageneration: String,
    content_type: String,
    time_created: String,
    updated: String,
    storage_class: String,
    size: String,
    md5_hash: String,
    content_encoding: String,
    content_disposition: String,
    crc32c: String,
    etag: String,
    download_tokens: String,
  )
}

//A function to turn UploadData into JSON
pub fn upload_data_to_json(upload_data upload_data: UploadData) -> String {
  object([
    #("name", string(upload_data.name)),
    #("bucket", string(upload_data.bucket)),
    #("generation", string(upload_data.generation)),
    #("metageneration", string(upload_data.metageneration)),
    #("contentType", string(upload_data.content_type)),
    #("timeCreated", string(upload_data.time_created)),
    #("updated", string(upload_data.updated)),
    #("storageClass", string(upload_data.storage_class)),
    #("size", string(upload_data.size)),
    #("md5Hash", string(upload_data.md5_hash)),
    #("contentEncoding", string(upload_data.content_encoding)),
    #("contentDisposition", string(upload_data.content_disposition)),
    #("crc32c", string(upload_data.crc32c)),
    #("etag", string(upload_data.etag)),
    #("downloadTokens", string(upload_data.download_tokens)),
  ])
  |> json.to_string
}

//A function to turn JSON into UploadData - adapted from https://github.com/emergent/decode-json-examples/blob/main/test/decode_json_test.gleam
pub fn json_to_upload_data(
  input input: Dynamic,
) -> Result(UploadData, List(DecodeError)) {
  let decoder = {
    use name <- decode.field("name", decode.string)
    use bucket <- decode.field("bucket", decode.string)
    use generation <- decode.field("generation", decode.string)
    use metageneration <- decode.field("metageneration", decode.string)
    use content_type <- decode.field("contentType", decode.string)
    use time_created <- decode.field("timeCreated", decode.string)
    use updated <- decode.field("updated", decode.string)
    use storage_class <- decode.field("storageClass", decode.string)
    use size <- decode.field("size", decode.string)
    use md5_hash <- decode.field("md5Hash", decode.string)
    use content_encoding <- decode.field("contentEncoding", decode.string)
    use content_disposition <- decode.field("contentDisposition", decode.string)
    use crc32c <- decode.field("crc32c", decode.string)
    use etag <- decode.field("etag", decode.string)
    use download_tokens <- decode.field("downloadTokens", decode.string)
    decode.success(UploadData(
      name:,
      bucket:,
      generation:,
      metageneration:,
      content_type:,
      time_created:,
      updated:,
      storage_class:,
      size:,
      md5_hash:,
      content_encoding:,
      content_disposition:,
      crc32c:,
      etag:,
      download_tokens:,
    ))
  }

  //Run the decoder
  decode.run(input, decoder)
}
