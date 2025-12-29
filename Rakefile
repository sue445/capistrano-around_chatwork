require "bundler/gem_tasks"

namespace :integration_test do
  integration_dir = File.join(__dir__, "spec", "integration")

  desc "start test server"
  task :start_server do
    Dir.chdir(integration_dir) do
      sh "docker image build . -t ssh_server"
      sh "docker run -d -p 10000:22 ssh_server"
    end
  end

  desc "stop test server"
  task :stop_server do
    Dir.chdir(integration_dir) do
      sh "docker kill $(docker ps -q --filter 'ancestor=ssh_server') || true"
    end
  end

  desc "Deploy to docker"
  task :deploy do
    require "dotenv/load"
    Dir.chdir(integration_dir) do
      sh "chmod 600 #{integration_dir}/config/id_ed25519"
      sh "bundle exec cap development deploy"
    end
  end

  desc "Run all integration test"
  task :all => %i(start_server deploy stop_server)
end
