prompt = function() {
  var host = db.serverStatus().host;
  return "\nmongo://" + host + "/" + db + "\n$ ";
}

DBQuery.prototype._prettyShell = true

