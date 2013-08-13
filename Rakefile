require 'bundler/setup'
require 'fileutils'

task :update_scripts do
  mkdir_p 'tmp'
  rm_rf 'tmp/hubot-scripts'
  `git clone git://github.com/github/hubot-scripts.git tmp/hubot-scripts`
end

task :read_scripts do
  require './brain'

  Dir.chdir('tmp/hubot-scripts')
  
  Dir['src/scripts/*.coffee'].each do |script|
    name = script.split('/').last
    print "Adding #{name}..."
    
    begin
      file = File.new(script, 'r')
      sections = {}
      current_section = nil
      
      # See Hubot's robot.coffee for how it approaches reading comments
      while line = file.gets
        break unless line[0] == "#"
        cleaned_line = line[2..line.length]
        
        if !cleaned_line.strip.empty? && cleaned_line.strip.downcase != "none"
          if cleaned_line[0..1] != "  "
            # "Commands:" => "commands"
            current_section = cleaned_line.strip.chomp(":").downcase
            sections[current_section] ||= ""
          else
            sections[current_section] << cleaned_line.lstrip
          end
        end
      end

      dates = `git log --format=%aD #{script}`.split("\n")

      sections['added_at'] = dates.last
      sections['last_updated_at'] = dates.first
      
      keys_values = sections.to_a.flatten
      $redis.hmset("scripts:#{name}", *keys_values)
      puts "OK"
    rescue => error
      puts "Error: #{error}"
    ensure
      file.close
    end
  end
  
  $redis[:last_updated] = Time.now
  
  puts "Scripts updated."
end

desc 'Retrieve and catalog the latest scripts'
task :catalog => [:update_scripts, :read_scripts]

desc 'Flush scripts'
task :flush do
  require './brain'
  
  $redis.keys('scripts:*').each do |key|
    begin
      print "Deleting #{key}..."
      $redis.del(key)
      puts "OK"
    rescue => error
      puts "Error: #{error}"
    end
  end
end

task :default => :catalog