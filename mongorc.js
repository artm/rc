prompt = function() {
  var host = db.serverStatus().host;
  return "\nMongo: " + db + '@' + host + "\n$ ";
}

DBQuery.prototype._prettyShell = true

