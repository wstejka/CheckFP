#!/home/wstejka/virtualenv/firebase/bin/python

import pyrebase

config = {
  "apiKey": "AIzaSyB5gJnV0cCayzgD5sZHhUCGovrJiPlozcU",
  "authDomain": "checkfuelprice-d5d3d.firebaseapp.com",
  "databaseURL": "https://checkfuelprice-d5d3d.firebaseio.com/",
  "storageBucket": "gs://checkfuelprice-d5d3d.appspot.com"
}

firebase = pyrebase.initialize_app(config)
db = firebase.database()
users = db.child("users").get()
print users.val()

data = {"name": "Mortimer 'Morty' Smith"}
db.child("users").child("Morty").set(data)

#db.child("users").child("-KkeICwFrUy_sKTs6xxw").remove()
#users = db.child("users").get()
#print users.val()