//gleam
import gleam/bit_array
import gleam/dynamic
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/string

//gleamyshell
import gleamyshell.{CommandOutput}

//simplifile
import simplifile

//zero/decode
import decode/zero as decode

///Firestore collection type
pub type Collection {
  Collection(location: String, err: String)
}

//Custom error type
pub type FireballError {
  //A generic error - will be expanded upon later
  FireballError(err: String)
}

///Firestore document type
pub type FireballDocument {
  // "data" is the fields section of a document
  FireballDocument(data: String)
}

///
pub type FireballStorage {
  FireballStorage(path: String)
}

///A type representing the JSON returning when uploading an object to Google Firebase Storage
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

///RTDB wrapper error
pub type RTDBError {
  Generic(err: String)
}

///Decode an RTDB error
pub fn decode_error(input input: String) -> Result(RTDBError, json.DecodeError) {
  json.decode(
    input,
    dynamic.decode1(Generic, dynamic.field("error", of: dynamic.string)),
  )
}

///put_file function to create a node in Google's Realtime Database
pub fn put_data(
  apikey apikey: String,
  input input: String,
  dbpath dbpath: String,
  dburl dburl: String,
) -> Result(String, RTDBError) {
  //Init url
  let url =
    //Firestore RTDB url
    dburl
    //DB Path
    <> dbpath
    <> ".json?auth="
    //Auth secret
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Put)
        //Set body
        |> request.set_body(input)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(resp.body)

        //Handle errors
        Error(err) -> {
          io.debug(err)
          Error(Generic(err: "error while sending request"))
        }
      }
    }
    //Handle errors
    Error(err) -> {
      io.debug(err)
      Error(Generic(err: "error while creating request"))
    }
  }
}

///put_file function to update fields in a node in Google's Realtime Database
pub fn patch_data(
  apikey apikey: String,
  input input: String,
  dbpath dbpath: String,
  dburl dburl: String,
) -> Result(String, RTDBError) {
  //Init url
  let url =
    //Firestore RTDB url
    dburl
    //DB Path
    <> dbpath
    <> ".json?auth="
    //Auth secret
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Patch)
        //Set body
        |> request.set_body(input)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(resp.body)

        //Handle errors
        Error(err) -> {
          io.debug(err)
          Error(Generic(err: "error while sending request"))
        }
      }
    }
    //Handle errors
    Error(err) -> {
      io.debug(err)
      Error(Generic(err: "error while creating request"))
    }
  }
}

///get_data function to get data from a node in Google's Realtime Database
pub fn get_data(
  apikey apikey: String,
  dbpath dbpath: String,
  dburl dburl: String,
) -> Result(String, RTDBError) {
  //Init url
  let url =
    //Firestore RTDB url
    dburl
    //DB Path
    <> dbpath
    <> ".json?auth="
    //Auth secret
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Get)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(resp.body)

        //Handle errors
        Error(err) -> {
          io.debug(err)
          Error(Generic(err: "error while sending request"))
        }
      }
    }
    //Handle errors
    Error(err) -> {
      io.debug(err)
      Error(Generic(err: "error while creating request"))
    }
  }
}

///get_doc function to retrieve a document from Google's Firestore Database
pub fn get_doc(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  doc doc: String,
  proj_id proj_id: String,
) -> Result(FireballDocument, FireballError) {
  //Init a request object
  case
    request.to(
      //Firestore url
      "https://firestore.googleapis.com/"
      //Firestore Web API version
      <> apiver
      <> "/projects/"
      //Project id
      <> proj_id
      <> "/databases/"
      //Database to use
      <> database
      <> "/documents/"
      //Document path
      <> doc
      <> "?key="
      //API Key for the google cloud project
      <> apikey,
    )
  {
    //Check output
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Get)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(FireballDocument(data: resp.body))

        //Handle errors
        Error(_) -> Error(FireballError(err: "error while sending request"))
      }
    }

    //Handle errors
    Error(_) -> Error(FireballError(err: "error while forming request"))
  }
}

///put_file function to create a document in Google's Firestore Database
pub fn post_doc(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_doc input_doc: FireballDocument,
  proj_id proj_id: String,
) -> Result(FireballDocument, FireballError) {
  //Init url
  let url =
    //Firestore url
    "https://firestore.googleapis.com/"
    //Firestore Web API version
    <> apiver
    <> "/projects/"
    //Project id
    <> proj_id
    <> "/databases/"
    //Database to use
    <> database
    <> "/documents/"
    //Collection path
    <> collection_path
    <> "?documentId="
    //Doc path
    <> doc_path
    //API Key for the google cloud project
    <> "&key="
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Post)
        |> request.set_body(doc_to_json(input_doc))

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(FireballDocument(data: resp.body))

        //Handle errors
        Error(_) -> Error(FireballError(err: "error while sending request"))
      }
    }
    //Handle errors
    Error(_) -> Error(FireballError(err: "error while creating request"))
  }
}

///put_file function to create a document in Google's Firestore Database
pub fn post_doc_from_string(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_data input_data: String,
  proj_id proj_id: String,
) -> Result(FireballDocument, FireballError) {
  //Init url
  let url =
    //Firestore url
    "https://firestore.googleapis.com/"
    //Firestore Web API version
    <> apiver
    <> "/projects/"
    //Project id
    <> proj_id
    <> "/databases/"
    //Database to use
    <> database
    <> "/documents/"
    //Collection path
    <> collection_path
    <> "?documentId="
    //Doc path
    <> doc_path
    //API Key for the google cloud project
    <> "&key="
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Add headers
      let req =
        //Add headers
        request.prepend_header(base_req, "Content-type", "application/json")
        //Set method
        |> request.set_method(http.Post)
        //Set body
        |> request.set_body(input_data)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(FireballDocument(data: resp.body))

        //Handle errors
        Error(_) -> Error(FireballError(err: "error while sending request"))
      }
    }
    //Handle errors
    Error(_) -> Error(FireballError(err: "error while creating request"))
  }
}

///put_file function to create a document in Google's Firestore Database
pub fn post_doc_from_file(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_doc input_doc: String,
  proj_id proj_id: String,
) -> Result(FireballDocument, FireballError) {
  //Init url
  let url =
    //Firestore url
    "https://firestore.googleapis.com/"
    //Firestore Web API version
    <> apiver
    <> "/projects/"
    //Project id
    <> proj_id
    <> "/databases/"
    //Database to use
    <> database
    <> "/documents/"
    //Collection path
    <> collection_path
    <> "?documentId="
    //Doc path
    <> doc_path
    //API Key for the google cloud project
    <> "&key="
    <> apikey

  //Init a request object
  case request.to(url) {
    //
    Ok(base_req) -> {
      //Get the data from the json file
      case simplifile.read(input_doc) {
        //If we found and read the file
        Ok(json_data) -> {
          //Add headers
          let req =
            //Add headers
            request.prepend_header(base_req, "Content-type", "application/json")
            //Set method
            |> request.set_method(http.Post)
            //Set body
            |> request.set_body(json_data)

          //Send the HTTP request to the server
          case httpc.send(req) {
            //Retrieve successful response
            Ok(resp) -> Ok(FireballDocument(data: resp.body))

            //Handle errors
            Error(_) -> Error(FireballError(err: "error while sending request"))
          }
        }

        //Handle errors
        Error(_) -> Error(FireballError(err: "failed to read file"))
      }
    }
    //Handle errors
    Error(_) -> Error(FireballError(err: "error while creating request"))
  }
}

///get_file function is used to retrieve a single file from Google's Firestore Storage
pub fn get_file(
  apiver apiver: String,
  obj_path obj_path: String,
  proj_id proj_id: String,
  token token: String,
  content_type content_type: String,
) -> Result(FireballStorage, FireballError) {
  //Init URL
  let url =
    //Firestore url
    "https://firebasestorage.googleapis.com/"
    //Firestore Web API version
    <> apiver
    <> "/b/"
    //Project id
    <> proj_id
    <> ".appspot.com/o/"
    //Object to get without leading slash
    <> string.replace(in: obj_path, each: "/", with: "%2F")
    <> "?alt=media&token="
    //Document path
    <> token

  //Init a request object
  case request.to(url) {
    //If we didn't have an error making the request
    Ok(base_req) -> {
      //Add headers
      let req =
        request.prepend_header(base_req, "Content-type", content_type)
        //Set method
        |> request.set_method(http.Get)

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(FireballStorage(path: resp.body))

        //Handle errors
        Error(_) -> Error(FireballError(err: "error while sending request"))
      }
    }

    //
    Error(_) -> Error(FireballError(err: "failed to create request"))
  }
}

//post_file function is used to upload a single file to Google's Firestore Storage as a Base64 encoded string
///This will change in the future if a native Multipart Form encoder is written for HTTPC
pub fn post_file(
  apiver apiver: String,
  apikey apikey: String,
  infile infile: String,
  outfile outfile: String,
  proj_id proj_id: String,
) -> Result(String, FireballError) {
  //Init a request object
  case
    request.to(
      //Firestore url
      "https://firestore.googleapis.com/"
      //Firestore Web API version
      <> apiver
      <> "/b/"
      //Project id
      <> proj_id
      <> ".appspot.com/o/"
      //Filepath without leading slash
      <> string.replace(in: outfile, each: "/", with: "%2F"),
    )
  {
    //Check output
    Ok(base_req) -> {
      //Read in the infile
      case simplifile.read_bits(infile) {
        //If we didnt have an eror
        Ok(raw_file_data) -> {
          //Encode as Base64 string
          let file_data = bit_array.base64_encode(raw_file_data, True)

          //Add headers
          let req =
            //Add headers
            request.prepend_header(base_req, "Content-type", "text/plain")
            |> request.set_header("Authorization", apikey)
            //Set body
            |> request.set_body(file_data)
            //Set method
            |> request.set_method(http.Post)

          //Send the HTTP request to the server
          case httpc.send(req) {
            //Retrieve successful response
            Ok(_) -> Ok("OK")

            //Handle errors
            Error(_) -> Error(FireballError(err: "error while sending request"))
          }
        }

        //If we have some kind of error while reading in the file
        Error(_) ->
          Error(FireballError(err: "Failed to read in file: " <> infile))
      }
    }

    //Handle errors
    Error(_) -> Error(FireballError(err: "error while forming request"))
  }
}

///post_file_erl function is used to call erlang's inets and ssl funtions to send the request over httpc
@external(erlang, "fireball_ffi", "post_file_erl")
pub fn post_file_erl(url url: String, infile infile: String) -> Nil

///post_file, but uses system cURL instead of native libaries
pub fn post_file_external(
  apiver apiver: String,
  apikey _apikey: String,
  infile infile: String,
  outfile outfile: String,
  proj_id proj_id: String,
  external_script external_script: String,
  wd wd: String,
) -> Result(String, FireballError) {
  //Setup url to send to subprocess
  let url =
    //Firestore url
    "https://firebasestorage.googleapis.com/"
    //Firestore Web API version
    <> apiver
    <> "/b/"
    //Project id
    <> proj_id
    <> ".appspot.com/o/"
    //Filepath without leading slash
    <> string.replace(in: outfile, each: "/", with: "%2F")

  //Run the command with system cURL
  case gleamyshell.execute(external_script, in: wd, args: [url, infile]) {
    //Handle zero exit
    Ok(CommandOutput(0, output)) -> Ok(string.trim(output))

    //Handle non-zero exit
    Ok(CommandOutput(exit_code, output)) ->
      Error(FireballError(
        err: "ERROR:" <> int.to_string(exit_code) <> ";" <> output,
      ))

    //Handle erlang / system error
    Error(reason) -> Error(FireballError(err: "FATAL_ERROR:" <> reason))
  }
}

///Function to transform a document into a semi-colon string
pub fn doc_to_string(doc doc: FireballDocument) -> String {
  doc.data
}

///Function to transform a document into a list of strings
pub fn doc_to_list(doc doc: FireballDocument) -> List(String) {
  [doc.data]
}

///Function to transform a document into a tuple of strings
pub fn doc_to_tuple(doc doc: FireballDocument) -> #(String) {
  #(doc.data)
}

///Function to transform a document into JSON
pub fn doc_to_json(doc doc: FireballDocument) -> String {
  json.object([#("name", json.string(doc.data))])
  |> json.to_string
}

///A function to turn UploadData into JSON
pub fn upload_data_to_json(upload_data upload_data: UploadData) -> String {
  json.object([
    #("name", json.string(upload_data.name)),
    #("bucket", json.string(upload_data.bucket)),
    #("generation", json.string(upload_data.generation)),
    #("metageneration", json.string(upload_data.metageneration)),
    #("contentType", json.string(upload_data.content_type)),
    #("timeCreated", json.string(upload_data.time_created)),
    #("updated", json.string(upload_data.updated)),
    #("storageClass", json.string(upload_data.storage_class)),
    #("size", json.string(upload_data.size)),
    #("md5Hash", json.string(upload_data.md5_hash)),
    #("contentEncoding", json.string(upload_data.content_encoding)),
    #("contentDisposition", json.string(upload_data.content_disposition)),
    #("crc32c", json.string(upload_data.crc32c)),
    #("etag", json.string(upload_data.etag)),
    #("downloadTokens", json.string(upload_data.download_tokens)),
  ])
  |> json.to_string
}

///A function to turn JSON into UploadData - adapted from https://github.com/emergent/decode-json-examples/blob/main/test/decode_json_test.gleam
pub fn json_to_upload_data(
  input input: dynamic.Dynamic,
) -> Result(UploadData, List(dynamic.DecodeError)) {
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
