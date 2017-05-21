const functions = require('firebase-functions');

//const admin = require('firebase-admin');
//admin.initializeApp(functions.config().firebase);
//
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
const http = require('http');
const util = require("util");

exports.helloWorld = functions.https.onRequest((request, response) => {
    console.log("Hello from Firebase! ELLO");
    
    var options = {
      host: 'www.lotos.pl',
      port: 80,
      path: '/'
    };

    console.log("Hello from Firebase! options:" + options.host);
    
//    http.get('http://www.lotos.pl/144/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw', (res) => {
    http.get('http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/default.aspx', (res) => {
      const { statusCode } = res;
      const contentType = res.headers['content-type'];

      let error;
      if (statusCode !== 200) {
        error = new Error(`Request Failed.\n` +
                          `Status Code: ${statusCode}`);
      } else if (!/^text\/html/.test(contentType)) {
        error = new Error(`Invalid content-type.\n` +
                          `Expected application/json but received ${contentType}`);
      }
      if (error) {
        console.error(error.message);
        // consume response data to free up memory
        res.resume();
        return;
      }

      console.log("XXX: " + JSON.stringify(res.headers))

      res.setEncoding('utf8');        
      let rawData = '';
      res.on('data', (chunk) => { rawData += chunk; });
      res.on('end', () => {
//        console.log("XXX: " + rawData)
//        try {
//          const parsedData = JSON.parse(rawData);
//          console.log(parsedData);
//        } catch (e) {
//          console.error(e.message);
//        }
    response.send("Hello from Firebase! END 1" + JSON.stringify(res.headers));
      });
    }).on('error', (e) => {
      console.error(`Got error: ${e.message}`);
    response.send("Hello from Firebase! END 2" + e.message);
    });
    
    
    
});

