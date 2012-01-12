require 'bundler/setup'
require 'fileutils'

task :update_scripts do
  mkdir 'tmp'
  rmdir 'tmp/hubot-scripts'
  exec 'git clone git://github.com/github/hubot-scripts.git tmp/hubot-scripts'
end

task :catalog => :update_scripts do
  require './brain'
  
  Dir['tmp/hubot-scripts/src/scripts/*.coffee'].each do |script|
    name = script.split('/').last
    
    begin
      file = File.new(script, 'r')
      description = ""
      commands = ""
      
      # See Hubot's robot.coffee for how it approaches reading comments
      while line = file.gets
        break unless (line[0] == "#" || line[0..1] == "//")
        cleaned_line = line.gsub(/^[#|\/\/]?/, '').lstrip
        
        if cleaned_line.match("-")
          commands << cleaned_line
        elsif !cleaned_line.strip.empty?
          description << cleaned_line
        end
      end
      
      $redis.hmset("scripts:#{name}", :description, description, :commands, commands)
    rescue => error
      puts "Error in #{name}: #{error}"
    ensure
      file.close
    end
  end
  
  $redis[:last_updated] = Time.now
end

task :default => :catalog