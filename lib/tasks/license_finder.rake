namespace :license do
  desc 'write out example config file'
  task :init do
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', '..', 'files', 'license_finder.yml'), './config/license_finder.yml')
  end

  desc 'generate a list of dependency licenses'
  task :generate_dependencies do
    LicenseFinder::Finder.new.write_files
  end

  desc 'action items'
  task :action_items => :generate_dependencies do
    found = LicenseFinder::Finder.new.action_items
    if found.size == 0
      puts "All gems are approved for use"
    else
      puts "Dependencies that need approval:"
      puts found
      exit 1
    end
  end

  desc 'return a failure status code for unapproved dependencies'
  task 'action_items:ok' => :generate_dependencies do
    puts "rake license:action_items:ok is deprecated and will be removed in version 1.0.  Use rake license:action_items instead."

    found = LicenseFinder::Finder.new.action_items
    if found.size == 0
      puts "All gems are approved for use"
    else
      exit 1
    end
  end
end
