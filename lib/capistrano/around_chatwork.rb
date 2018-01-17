require "capistrano/around_chatwork/version"
require "cha"

module Capistrano
  module AroundChatwork
    def self.format_message(message:, task_name:, elapsed_time: 0)
      message.gsub(":task_name:", task_name).gsub(":elapsed_time:", sprintf("%5.3f", elapsed_time))
    end

    def self.post_chatwork(message)
      client = Cha.new(api_token: fetch(:chatwork_api_token))
      client.create_room_message(fetch(:chatwork_room_id), message)
    end
  end
end

def around_chatwork(task_name)
  start_time = nil

  before_task = Rake::Task.define_task("#{task_name}:__before__") do
    message = Capistrano::AroundChatwork.format_message(
      message:   fetch(:starting_message),
      task_name: task_name,
    )
    Capistrano::AroundChatwork.post_chatwork(message)
    start_time = Time.now
  end

  after_task = Rake::Task.define_task("#{task_name}:__after__") do
    elapsed_time = Time.now - start_time
    message = Capistrano::AroundChatwork.format_message(
      message:      fetch(:ending_message),
      task_name:    task_name,
      elapsed_time: elapsed_time,
    )
    Capistrano::AroundChatwork.post_chatwork(message)
  end

  Rake::Task[task_name].enhance([before_task]) do
    Rake::Task[after_task].invoke
  end
end

set :starting_message, -> {
  "[info][title][#{fetch(:stage)}] :task_name: @#{fetch(:user)}[/title]started[/info]"
}

set :ending_message, -> {
  "[info][title][#{fetch(:stage)}] :task_name: @#{fetch(:user)}[/title]done (:elapsed_time: sec)[/info]"
}

set :user, local_user
