exports.handler =  async function(event, context) {
  console.log("EVENT: \n" + JSON.stringify(event, null, 2))
  console.log("Siddhant purushothaman harsha hepzibah")
  console.log("hellooooo")
  return context.logStreamName
}
