//gleam
import gleam/bit_array
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/string

//gleamyshell
import gleamyshell.{CommandOutput}

//simplifile
import simplifile

//Import firebase objects, document type
import error
import objects/document
import objects/storage

//get_doc function to retrieve a document from Google's Firestore Database
pub fn get_doc(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  doc doc: String,
  proj_id proj_id: String,
) -> Result(document.FireballDocument, error.FireballError) {
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
        Ok(resp) -> Ok(document.FireballDocument(data: resp.body))

        //Handle errors
        Error(_) ->
          Error(error.FireballError(err: "error while sending request"))
      }
    }

    //Handle errors
    Error(_) -> Error(error.FireballError(err: "error while forming request"))
  }
}

//put_file function to create a document in Google's Firestore Database
pub fn put_doc(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_doc input_doc: document.FireballDocument,
  proj_id proj_id: String,
) -> Result(document.FireballDocument, error.FireballError) {
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
        |> request.set_body(document.doc_to_json(input_doc))

      //Send the HTTP request to the server
      case httpc.send(req) {
        //Retrieve successful response
        Ok(resp) -> Ok(document.FireballDocument(data: resp.body))

        //Handle errors
        Error(_) ->
          Error(error.FireballError(err: "error while sending request"))
      }
    }
    //Handle errors
    Error(_) -> Error(error.FireballError(err: "error while creating request"))
  }
}

//put_file function to create a document in Google's Firestore Database
pub fn put_doc_from_string(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_data input_data: String,
  proj_id proj_id: String,
) -> Result(document.FireballDocument, error.FireballError) {
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
        Ok(resp) -> Ok(document.FireballDocument(data: resp.body))

        //Handle errors
        Error(_) ->
          Error(error.FireballError(err: "error while sending request"))
      }
    }
    //Handle errors
    Error(_) -> Error(error.FireballError(err: "error while creating request"))
  }
}

//put_file function to create a document in Google's Firestore Database
pub fn put_doc_from_file(
  apikey apikey: String,
  apiver apiver: String,
  database database: String,
  collection_path collection_path: String,
  doc_path doc_path: String,
  input_doc input_doc: String,
  proj_id proj_id: String,
) -> Result(document.FireballDocument, error.FireballError) {
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
            Ok(resp) -> Ok(document.FireballDocument(data: resp.body))

            //Handle errors
            Error(_) ->
              Error(error.FireballError(err: "error while sending request"))
          }
        }

        //Handle errors
        Error(_) -> Error(error.FireballError(err: "failed to read file"))
      }
    }
    //Handle errors
    Error(_) -> Error(error.FireballError(err: "error while creating request"))
  }
}

//get_file function is used to retrieve a single file from Google's Firestore Storage
pub fn get_file(
  apiver apiver: String,
  obj_path obj_path: String,
  proj_id proj_id: String,
  token token: String,
  content_type content_type: String,
) -> Result(storage.FireballStorage, error.FireballError) {
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
        Ok(resp) -> Ok(storage.FireballStorage(path: resp.body))

        //Handle errors
        Error(_) ->
          Error(error.FireballError(err: "error while sending request"))
      }
    }

    //
    Error(_) -> Error(error.FireballError(err: "failed to create request"))
  }
}

//post_file function is used to upload a single file to Google's Firestore Storage as a Base64 encoded string
//This will change in the future if a native Multipart Form encoder is written for HTTPC
pub fn post_file(
  apiver apiver: String,
  apikey apikey: String,
  infile infile: String,
  outfile outfile: String,
  proj_id proj_id: String,
) -> Result(String, error.FireballError) {
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
            Error(_) ->
              Error(error.FireballError(err: "error while sending request"))
          }
        }

        //If we have some kind of error while reading in the file
        Error(_) ->
          Error(error.FireballError(err: "Failed to read in file: " <> infile))
      }
    }

    //Handle errors
    Error(_) -> Error(error.FireballError(err: "error while forming request"))
  }
}

//post_file_erl function is used to call erlang's inets and ssl funtions to send the request over httpc
@external(erlang, "fireball_ffi", "post_file_erl")
pub fn post_file_erl(url url: String, infile infile: String) -> Nil

//post_file, but uses system cURL instead of native libaries
pub fn post_file_external(
  apiver apiver: String,
  apikey _apikey: String,
  infile infile: String,
  outfile outfile: String,
  proj_id proj_id: String,
  external_script external_script: String,
  wd wd: String,
) -> Result(String, error.FireballError) {
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
      Error(error.FireballError(
        err: "ERROR:" <> int.to_string(exit_code) <> ";" <> output,
      ))

    //Handle erlang / system error
    Error(reason) -> Error(error.FireballError(err: "FATAL_ERROR:" <> reason))
  }
}
