require 'webrick'
server = WEBrick::HTTPServer.new(:Port => 3000)
server.mount_proc("/") do |request, response|
  path = request.path
  response.content_type = "text/text"
  if path != "/"
    response.body = "#{path} #{request.body}"
  else
    response.body = "/ey/yo"
  end
end
trap('INT') do
  server.shutdown
end

server.start
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
