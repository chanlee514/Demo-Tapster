worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 30
#preload_app true
working_directory "/app"
pid "/app/unicorn/unicorn.pid"
stderr_path "/app/unicorn/unicorn.log"
stdout_path "/app/unicorn/unicorn.log"
listen "/tmp/unicorn.tapster.sock"
