import gleam/dynamic.{type DecodeError, type Decoder, type Dynamic, field}
import gleam/json.{object, string}

//
import gleam/list

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

//Code adapted from gleam/dynamic function all_errors
fn all_errors(result: Result(a, List(DecodeError))) -> List(DecodeError) {
  case result {
    Ok(_) -> []
    Error(errors) -> errors
  }
}

//Code adapted from gleam/dynamic decode9 function
fn decode15(
  constructor: fn(
    t1,
    t2,
    t3,
    t4,
    t5,
    t6,
    t7,
    t8,
    t9,
    t10,
    t11,
    t12,
    t13,
    t14,
    t15,
  ) ->
    t,
  t1: Decoder(t1),
  t2: Decoder(t2),
  t3: Decoder(t3),
  t4: Decoder(t4),
  t5: Decoder(t5),
  t6: Decoder(t6),
  t7: Decoder(t7),
  t8: Decoder(t8),
  t9: Decoder(t9),
  t10: Decoder(t10),
  t11: Decoder(t11),
  t12: Decoder(t12),
  t13: Decoder(t13),
  t14: Decoder(t14),
  t15: Decoder(t15),
) -> Decoder(t) {
  fn(x: Dynamic) {
    case
      t1(x),
      t2(x),
      t3(x),
      t4(x),
      t5(x),
      t6(x),
      t7(x),
      t8(x),
      t9(x),
      t10(x),
      t11(x),
      t12(x),
      t13(x),
      t14(x),
      t15(x)
    {
      Ok(a),
        Ok(b),
        Ok(c),
        Ok(d),
        Ok(e),
        Ok(f),
        Ok(g),
        Ok(h),
        Ok(i),
        Ok(j),
        Ok(k),
        Ok(l),
        Ok(m),
        Ok(n),
        Ok(o)
      -> Ok(constructor(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o))
      a, b, c, d, e, f, g, h, i, j, k, l, m, n, o ->
        Error(
          list.flatten([
            all_errors(a),
            all_errors(b),
            all_errors(c),
            all_errors(d),
            all_errors(e),
            all_errors(f),
            all_errors(g),
            all_errors(h),
            all_errors(i),
            all_errors(j),
            all_errors(k),
            all_errors(l),
            all_errors(m),
            all_errors(n),
            all_errors(o),
          ]),
        )
    }
  }
}

//A function to turn JSON into UploadData - adapted from https://github.com/emergent/decode-json-examples/blob/main/test/decode_json_test.gleam
pub fn json_to_upload_data(
  input input: String,
) -> Result(UploadData, json.DecodeError) {
  //Create a new decoder - needs to take a dynamic string, not a json string
  let upload_data_decoder =
    decode15(
      UploadData,
      field(named: "name", of: dynamic.string),
      field(named: "bucket", of: dynamic.string),
      field(named: "generation", of: dynamic.string),
      field(named: "metageneration", of: dynamic.string),
      field(named: "content_type", of: dynamic.string),
      field(named: "time_created", of: dynamic.string),
      field(named: "updated", of: dynamic.string),
      field(named: "storage_class", of: dynamic.string),
      field(named: "size", of: dynamic.string),
      field(named: "md5_hash", of: dynamic.string),
      field(named: "content_encoding", of: dynamic.string),
      field(named: "content_disposition", of: dynamic.string),
      field(named: "crc32c", of: dynamic.string),
      field(named: "etag", of: dynamic.string),
      field(named: "download_tokens", of: dynamic.string),
    )

  //Decode the input json
  json.decode(from: input, using: upload_data_decoder)
}
