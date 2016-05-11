require 'rubygems'
require_relative 'redmine'
require_relative 'issue'
require 'json'

AfterConfiguration do |cucumber_config|

  $config = YAML.load_file(File.dirname(__FILE__) + '/config.yml')
  $config[:html] = cucumber_config.formats[0][0] == 'html'

  USE_DUMP_FILE_FOR_DEBUGGING = false

  if USE_DUMP_FILE_FOR_DEBUGGING
    $stderr.puts 'Note, USE_DUMP_FILE_FOR_DEBUGGING is on, pulling local database'
    File.open('dump') { |file| $issues = JSON.load(file) }
  else
    $issues = {}
    Redmine.issues($config).each { |issue| $issues[issue['id']] = Issue.dehydrate(issue) }
    File.open('dump', 'w+') { |file| JSON.dump($issues, file) }
  end

end
