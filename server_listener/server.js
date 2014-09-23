var mysql = require("mysql");
var net = require('net');

var db = mysql.createConnection({
    host: config.db_host,
    user: config.db_user,
    password: config.db_pass,
    database: config.db_name
});

// Log any errors connected to the db
db.connect(function (err) {
    if (err) console.log(err)
});

//db.query('INSERT INTO `node_listener` (`message`) VALUES (?)', data.note);

/*var sockets = [];

 // Clean input
 function cleanInput(data) {
 return data.toString().replace(/(\r\n|\n|\r)/gm,"");
 }

 // Callback method executed when data is received from a socket
 function receiveData(socket, data) {
 var cleanData = cleanInput(data);
 for(var i = 0; i<sockets.length; i++) {
 if (sockets[i] !== socket) {
 sockets[i].write(data);
 }
 }
 }

 // Method executed when a socket ends
 function closeSocket(socket) {
 var i = sockets.indexOf(socket);
 if (i != -1) {
 sockets.splice(i, 1);
 }
 }

 // Callback method executed when a new TCP socket is opened.
 function newSocket(socket) {
 sockets.push(socket);
 socket.write('welcome');
 socket.on('data', function(data) {
 receiveData(socket, data);
 })
 .on('end', function() {
 closeSocket(socket);
 })
 }

 // Create a new server and provide a callback for when a connection occurs
 var server = net.createServer(newSocket);

 // Listen on port
 server.listen(4445);
 */

var HOST = '127.0.0.1';
var PORT = 4445;

function cleanInput(data) {
    return data.toString().replace(/(\r\n|\n|\r)/gm, "");
}

function tryParseJSON(jsonString) {
    try {
        var o = JSON.parse(jsonString);

        // Handle non-exception-throwing cases:
        // Neither JSON.parse(false) or JSON.parse(1234) throw errors, hence the type-checking,
        // but... JSON.parse(null) returns 'null', and typeof null === "object",
        // so we must check for that, too.
        if (o && typeof o === "object" && o !== null) {
            return o;
        }
    }
    catch (e) {
    }

    return false;
}

// Create a server instance, and chain the listen function to it
// The function passed to net.createServer() becomes the event handler for the 'connection' event
// The sock object the callback function receives UNIQUE for each connection
net.createServer(function (sock) {

    sock.write('welcome\n');

    // We have a connection - a socket object is assigned to the connection automatically
    console.log('CONNECTED: ' + sock.remoteAddress + ':' + sock.remotePort);

    // Add a 'data' event handler to this instance of socket
    sock.on('data', function (data) {
        data = cleanInput(data);

        console.log('DATA ' + sock.remoteAddress + ':' + sock.remotePort + ' -- ' + data);
        // Write the data back to the socket, the client will receive it as data from the server
        sock.write('You said "' + data + '"\n');

        if (tryParseJSON(data)) {
            db.query('INSERT INTO `node_listener` (`message`) VALUES (?)', data);
        }
    });

    sock.on('close', function (data) {
        console.log('CLOSED: ' + sock.remoteAddress + ':' + sock.remotePort);
    });

    sock.on('error', function (data) {
        console.log('ERROR: ' + sock.remoteAddress + ':' + sock.remotePort + ' -- ' + data);
    });

    sock.on('timeout', function (data) {
        console.log('TIMEOUT: ' + sock.remoteAddress + ':' + sock.remotePort + ' -- ' + data);
    });

}).listen(PORT, HOST);

console.log('Server listening on ' + HOST + ':' + PORT);