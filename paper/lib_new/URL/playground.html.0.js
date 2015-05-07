
function id(id) {
  return document.getElementById(id)
}

function setBase(base) {
  id("base").href = base
}

function bURL(url) {
  setBase("about:blank")
  var a = document.createElement("a")
  a.setAttribute("href", url)
  return a
}

function testProtocol(url) {
  var b = new bURL(url),
      s = new URL(url)
  document.write(b.protocol + " || " + s.protocol + " || " + b.href)
  document.write("<br>")
}

function testPath(url) {
  var b = new bURL(url),
      s = new URL(url)
  document.write(s.pathname + " || " + b.pathname)
  document.write("<br>")
}

function testSearch(url) {
  var b = new bURL(url),
      s = new URL(url)
  document.write(s.search + " || " + b.search)
  document.write("<br>")
}

function testHash(url) {
  var b = new bURL(url),
      s = new URL(url)
  document.write(s.hash + " " + s.hash.length + " || " + b.hash + " " + b.hash.length)
  document.write("<br>")
}

function testHost(url) {
  var b = new bURL(url),
      s = new URL(url)
  document.write(s.href + " || " + b.href)
  document.write("<br>")
}

function setPathname(path) {
  var s = new URL("data:text/html,test"),
      sb = new bURL("data:text/html,test"),
      z = new URL("http://test/trala/test/b/d"),
      zb = new bURL("http://test/trala/test/b/d")
  document.write(s.pathname + " " + z.pathname + " || " + sb.pathname + " " + zb.pathname)
  document.write("<br>")
  s.pathname = path
  z.pathname = path
  sb.pathname = path
  zb.pathname = path
  document.write(s.pathname + " " + z.pathname + " || " + sb.pathname + " " + zb.pathname)
  document.write("<br><br>")
}

function setSearch(path) {
  var s = new URL("data:text/html,test?x"),
      sb = new bURL("data:text/html,test?x"),
      z = new URL("http://test/trala/test/b/d?x"),
      zb = new bURL("http://test/trala/test/b/d?x")
  document.write(s.search + " " + z.search + " || " + sb.search + " " + zb.search)
  document.write("<br>")
  s.search = path
  z.search = path
  sb.search = path + "X"
  zb.search = path + "X"
  document.write(s.search + " " + z.search + " || " + sb.search + " " + zb.search)
  document.write("<br><br>")
}

function setScheme(path) {
  var s = new URL("data:text/html,test?x"),
      sb = new bURL("data:text/html,test?x"),
      z = new URL("http://test/trala/test/b/d?x"),
      zb = new bURL("http://test/trala/test/b/d?x")
  document.write(s.protocol + " " + z.protocol + " || " + sb.protocol + " " + zb.protocol + " " + sb.href + " " + zb.href)
  document.write("<br>")
  s.protocol = path
  z.protocol = path
  sb.protocol = path
  zb.protocol = path
  document.write(s.protocol + " " + z.protocol + " || " + sb.protocol + " " + zb.protocol + " " + sb.href + " " + zb.href)
  document.write("<br><br>")
}


function setHost(path) {
      z = new URL("http://test/trala/test/b/d?x"),
      zb = new bURL("http://test/trala/test/b/d?x")
  document.write(z.host + " || " + zb.host + " " + zb.href)
  document.write("<br>")
  z.host = path
  zb.host = path
  document.write(z.host + " || " + zb.host + " " + zb.href)
  document.write("<br><br>")
}

function setHostname(path) {
      z = new URL("http://x/trala/test/b/d?x"),
      zb = new bURL("http://x/trala/test/b/d?x")
  document.write(z.hostname + " || " + zb.hostname + " " + zb.href)
  document.write("<br>")
  z.hostname = path
  zb.hostname = path
  document.write(z.hostname + " || " + zb.hostname + " " + zb.href)
  document.write("<br><br>")
}



var protocolTests = [
  "HttPs: test",
  "DATA:test",
  ":test",
  "7:test",
  "™:test",
  "a a:test",
  "unknown:test",
  "unknown :test",
  "A5A.T:x",
  "http:exam™ple.org",
  "http:exam ple.org",
  "http:test",
  "http:test ",
  "http:maraña.org",
  "http://\0example.org/",
  "http://example.org/\0  \ntest",
  "HTTP://m%41rana.org/%41/",
  "http:%FF/",
  "http:&test!/",
  "http:'",
  "http:xn--test.org/test/test/sd\\f™",
  "http://test/!\"%<>`{|}",
  "http://s/?\\#<>\t!@#"
]

//protocolTests.forEach(...)

//testSearch("http://s/?\\  \t\n\fQ")
//testPath("http://s/  \t\n\f\x0D Q")
//testHash("http://s/#  \t\n\f\x01Q")
/*
testHost("http://@@@test:900\\/fd")
testHost("http://test?test")
testHost("http://test#test")
testHost("http://test/\\test")
testHost("http://test:90099991111119/a\\../b//x/./s")
testHost("datA:\\'test")
testHost("http://s/x///../test/")
testHost("http://s/../x/x")
testHost("http://example.com:80/")
testHost("http://Example.com/")
testHost("http://example.com/%7esmith/")
testHost("http://example.com:/")
testHost("http://abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz™/")
testHost("http://abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz™/")

document.write("<br>")
setPathname("../test/ppp/?../#\\")

setSearch("??##test")
*/

/*

setScheme("tralal")
setScheme("https")
setScheme("1tes")
setScheme(" tes")

*/

/*

setHost("x:34")
setHost("x:fds")
setHost("x#")
setHost("\n")

*/

setHostname("test:test")
setHostname("test")
setHostname("#")

