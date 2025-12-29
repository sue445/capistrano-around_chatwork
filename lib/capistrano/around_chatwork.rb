require "capistrano/around_chatwork/version"
require "chatwork"

module Capistrano
  module AroundChatwork
    def self.format_message(message:, task_name:, elapsed_time: 0, error: nil)
      return "" unless message

      formatted_message = message.
        gsub(":task_name:", task_name).
        gsub(":elapsed_time:", sprintf("%5.3f", elapsed_time))

      if error
        formatted_message = formatted_message.
          gsub(":error_message:", error.message).
          gsub(":error_inspect:", error.inspect).
          gsub(":error_backtrace:", error.backtrace.join("\n"))
      end

      formatted_message
    end

    def self.post_chatwork(message)
      return if message.empty?

      client = ChatWork::Client.new(api_key: fetch(:chatwork_api_token))
      client.create_message(room_id: fetch(:chatwork_room_id), body: message)
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

  target_task = Rake::Task[task_name]

  target_task.instance_eval do
    define_singleton_method :invoke_with_failure_message do |*args|
      begin
        invoke_without_failure_message(*args)
      rescue Exception => error
        elapsed_time = Time.now - start_time
        message = Capistrano::AroundChatwork.format_message(
          message:      fetch(:failure_message),
          task_name:    task_name,
          elapsed_time: elapsed_time,
          error:        error,
        )
        Capistrano::AroundChatwork.post_chatwork(message)
        raise
      end
    end
    alias :invoke_without_failure_message :invoke
    alias :invoke :invoke_with_failure_message
  end

  target_task.enhance([before_task]) do
    Rake::Task[after_task].invoke
  end
end

set :starting_message, -> {
  "[info][title][#{fetch(:stage)}] :task_name: @#{fetch(:user)}[/title]started[/info]"
}

set :ending_message, -> {
  "[info][title][#{fetch(:stage)}] :task_name: @#{fetch(:user)}[/title]done (:elapsed_time: sec)[/info]"
}

set :failure_message, -> {
  <<-MSG
[info][title][#{fetch(:stage)}] :task_name: @#{fetch(:user)}[/title]failed (:elapsed_time: sec)
:error_inspect:
:error_backtrace:[/info]
  MSG
}

set :user, local_user
