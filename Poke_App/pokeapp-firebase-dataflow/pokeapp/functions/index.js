'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const {WebhookClient} = require('dialogflow-fulfillment');

 
process.env.DEBUG = 'dialogflow:*'; // enables lib debugging statements
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
db.settings({timestampsInSnapshots: true});

 
exports.dialogflowFirebaseFulfillment = functions.https.onRequest((request, response) => {
  const agent = new WebhookClient({ request, response });

 

  function readFromDb (agent) {
    const valus = agent.parameters.given-name;
    console.log(`Conexion establecida ${valus}`);
    // Get the database collection 'dialogflow' and document 'agent'
    const dialogflowAgentDoc = db.collection('noticias').doc(valus);
    
    // Get the value of 'entry' in the document and send it to the user
    return dialogflowAgentDoc.get()
      .then(doc => {
        if (!doc.exists) {
          agent.add('No data found in the database!');
          console.log("No data found in the database!");
        } else {
          var value = doc.data();
          agent.add(`Es : ${value.noticia} `);
          
          
        }
        return Promise.resolve('Read complete');
      }).catch(() => {
        agent.add('Error reading entry from the Firestore database.');
        agent.add('Please add a entry to the database first by saying, "Write <your phrase> to the database"');
      });
  }

  // Map from Dialogflow intent names to functions to be run when the intent is matched
  let intentMap = new Map();
  intentMap.set('noticia', readFromDb);
  //intentMap.set('Cantidad material', writeToDb);
  agent.handleRequest(intentMap);
});

// Set the DialogflowApp object to handle the HTTPS POST request.
exports.dialogflowFirebaseFulfillment = functions.https.onRequest(app);
