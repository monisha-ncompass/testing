exports.handler =  async function(event, context) {
  console.log("EVENT: \n" + JSON.stringify(event, null, 2))
  console.log("Siddhant purushothaman harsha hepzibah")
  console.log("hellooooo")
  return {
    statusCode: 200,
    headers:{    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "*",
    "Content-Type": "application/json"},
    body: "Siddhant purushothaman harsha"
  }
 }
