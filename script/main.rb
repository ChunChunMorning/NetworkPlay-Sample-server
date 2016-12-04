require "socket"

server = TCPServer.open("127.0.0.1", 50000);

puts "Server is running at 50000."

parent = server.accept();
puts("Parent come\n");
parent.write("welcome\n");

child = server.accept();
puts("Child come\n");

time = Time.now.to_i + 3;

parent.write("start,#{time}\nisParent\n");
child.write("welcome\nstart,#{time}\n");

threads = Array.new();

threads << Thread.new {
  loop {
    message = parent.gets();

    if (message.nil?())
      break;
    end

    puts("parent: #{message}");
    args = message.chop().split(",");

    if (args[0] == "move")
      parent.write("parent," + args[1] + "\n");
      child.write("parent," + args[1] + "\n");
    elsif (args[0] == "goal")
      parent.write("goal\n");
      child.write("goal\n");
    end
  }
}

threads << Thread.new {
  loop {
    message = child.gets();

    if (message.nil?())
      break;
    end

    puts("child: #{message}");
    args = message.split(",");

    if (args[0] == "move")
      parent.write("child," + args[1]);
      child.write("child," + args[1]);
    end
  }
}

threads.each { |thread|
  thread.join();
}
