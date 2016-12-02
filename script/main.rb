require "socket"

server = TCPServer.open("127.0.0.1", 50000);

puts "Server is running at 50000."

socket = server.accept();

loop {
  message = socket.gets();
  puts(message);
  socket.write(message);
}
