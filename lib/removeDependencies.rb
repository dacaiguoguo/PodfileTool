require 'xcodeproj'
# ruby removeDe.rb pathof project

project_path = ARGV[0]
project = Xcodeproj::Project.open(project_path)
# puts project
project.targets.each do |target|
  if target.name == 'mymm'
    target.dependencies.each { |e|  puts e.remove_from_project }
  end
end

project.save

project_path = ARGV[0]
project = Xcodeproj::Project.open(project_path)
# puts project
project.targets.each do |target|
  if target.name == 'mymm'
    target.dependencies.each { |e|  puts e.remove_from_project }
  end
end

project.save