require 'cocoapods'
require 'json'
require 'xcodeproj'
require 'cocoapods-core'
require 'uri'
# tool of pod
class PodTool
  # parse Cocoapods Podfile to json
  #
  # Example:
  #   >> PodfileTool.outputJson("/path_of_Podfile")
  #   => {json}
  #
  # Arguments:
  #   path: (path_of_Podfile)
  # output to file name Podfile.json
  # Example2:
  #   >> PodfileTool.outputJsonFile("/path_of_Podfile")
  #   => {json}
  #
  # Arguments:
  #   path: (path_of_Podfile)
  def self.output_json(path)
    if File.file?(path)
      podfile_hash = Pod::Podfile.from_file(path).to_hash
      podfile_json = JSON.pretty_generate(podfile_hash)
      puts podfile_json
    else
      puts 'need Podfile Path!!!'
    end
  end

  #
  # share pod project scheme，Share a User Scheme. Basically this method move the xcscheme file from the xcuserdata folder to xcshareddata folder.
  # Arguments:
  #  pods_project_path:(pods_project_path)
  # Example3:
  # >> PodfileTool.sharePodScheme("/path_of_Pod_project")
  # => "Success share #{pod_name}"
  #
  #
  def self.share_pod_scheme(pods_project_path, pod_name)
    project = Xcodeproj::Project.open(pods_project_path)
    schemes = Xcodeproj::Project.schemes(pods_project_path)
    unless schemes.include? pod_name
      Xcodeproj::XCScheme.share_scheme(project.path, pod_name)
    end
    puts "Success share #{pod_name}"
  end

  def self.share_all_pod_scheme(pods_project_path)
    project = Xcodeproj::Project.open(pods_project_path)
    project.targets.each do |e|
      begin
        Xcodeproj::XCScheme.share_scheme(project.path, e.name)
        puts "Success share #{e.name}"
      rescue => err
        puts "Fail share #{e.name}"
        puts err
      end
    end
    project.save
  end

  #
  # remove a target of project
  # Arguments:
  #  project_path:(project_path)
  #  target_to_remove:(target_to_remove)
  # Example4:
  # >>  PodfileTool.removeTarget(args[0], args[1])
  # => puts "#{target.name} did remove from project!!"
  #
  #
  def self.remove_target(project_path, target_to_remove)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      if target.name == target_to_remove
        target.remove_from_project
        puts "#{target.name} did remove from project!!"
      end
    end
    project.save
  end

  #
  # remove a target frame_search_path of project
  # Arguments:
  #  project_path:(project_path)
  #  target_to_remove:(target_to_remove)
  #  frame_search_path:(frame_search_path)
  # Example4:
  # >>  PodfileTool.removeTargetFrameSearchPath(args[0], args[1], args[1])
  # => puts search_paths
  #
  #
  def self.remove_target_frame_search_path(project_path, target_to_remove, frame_search_path)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      next unless target.name == target_to_remove
      puts target.name
      target.build_configurations.each do |configuration|
        search_paths = configuration.build_settings['FRAMEWORK_SEARCH_PATHS'] ||= '$(inherited)'
        if search_paths.is_a? Array
          search_paths.delete_if { |e| e == frame_search_path }
        end
        puts "FRAMEWORK_SEARCH_PATHS:#{search_paths}"
      end
    end
    project.save
  end

  def self.remove_phase(project_path, target_to_remove, p_toremove)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      # puts target.name
      next unless target.name == target_to_remove
      # puts target.methods
      target.build_phases.each do |atarget|
        puts atarget.display_name
        if atarget.display_name == p_toremove
          atarget.remove_from_project
          puts "#{target.name} #{aP} did remove"
        end
        project.save
      end
    end
  end

  def self.unescape(to)
    puts URI.unescape(to)
  end
end
