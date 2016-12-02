require "socket"

server = TCPServer.open("127.0.0.1", 50000);

puts "Server is running at 50000."

parent = server.accept();
puts("Parent come\n");
parent.write("welcome\n");

child = server.accept();
puts("Child come\n");

parent.write("start\nparent\n");
child.write("welcome\nstart\n");

threads = Array.new();

threads << Thread.new {
  loop {
    message = parent.gets();

    if (message.nil?())
      break;
    end

    puts("parent: #{message}");
    parent.write(message);
    child.write(message);
  }
}

threads << Thread.new {
  loop {
    message = child.gets();

    if (message.nil?())
      break;
    end

    puts("child: #{message}");
    parent.write(message);
    child.write(message);
  }
}

threads.each { |thread|
  thread.join();
}
