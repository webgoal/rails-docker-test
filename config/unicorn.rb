@dir = File.expand_path(File.dirname(__FILE__)) + "/.."

worker_processes 2
working_directory @dir

timeout 30

listen File.join(@dir, '/tmp/sockets/unicorn.sock')

pid File.join(@dir, '/tmp/pids/unicorn.pid')

stderr_path File.join(@dir, 'log/unicorn.stderr.log')
stdout_path File.join(@dir, 'log/unicorn.stdout.log')

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
Gravatar
