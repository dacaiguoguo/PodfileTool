require 'xcodeproj'
# ruby remove_dependencies.rb <pathof project> <target name>

project_path = ARGV.first
to_remove_target_name = ARGV.last
project = Xcodeproj::Project.open(project_path)
project.save
modfiy_target = project.targets.find { |e| e.name == to_remove_target_name }
exit 1 if modfiy_target.nil?

exit 0 if modfiy_target.dependencies.empty?

puts modfiy_target.dependencies.map { |e| e.display_name }

for item_temp in modfiy_target.dependencies
  project_temp = Xcodeproj::Project.open(project_path)
  modfiy_target_temp = project_temp.targets.find { |e| e.name == to_remove_target_name }
  first_dependency = modfiy_target_temp.dependencies.first
  puts "Remove #{first_dependency.display_name}"
  first_dependency.remove_from_project
  project_temp.save
end



