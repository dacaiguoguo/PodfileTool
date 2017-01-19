require 'cocoapods'
require 'json'
require 'xcodeproj'
require 'cocoapods-core'

class PodfileTool
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
  def self.outputJson(path)
    if path
      if path.empty?
        puts 'need good Podfile Path!!!'
      else
        if File.exist?(path)
          if File.file?(path)
            podfile_hash = Pod::Podfile.from_file(path).to_hash
            podfile_json = JSON.pretty_generate(podfile_hash)
            podfile_json
          else
            puts 'Podfile Path is not a file!!!'
          end
        else
          puts 'need exist Podfile Path!!!'
        end
      end
    else
      puts 'need Podfile Path!!!'
    end
  end

  def self.outputJsonFile(path)
    podfile_hash = Pod::Podfile.from_file(path).to_hash
    podfile_json = JSON.pretty_generate(podfile_hash)
    aFile = File.new(Dir.pwd+"/Podfile.json", "w")
    if aFile
        aFile.syswrite(podfile_json)
    else
        puts "Unable to open file!"
    end
  end
  #
  # share pod project scheme，Share a User Scheme. Basically this method move the xcscheme file from the xcuserdata folder to xcshareddata folder.
  #Arguments:
  #  pods_project_path:(pods_project_path)
  # Example3:
  # >> PodfileTool.sharePodScheme("/path_of_Pod_project")
  # => "Success share #{pod_name}"
  #
  #
  def self.sharePodScheme(pods_project_path)
    pod_name = pods_project_path.split('/')[-4]
    project = Xcodeproj::Project.open(pods_project_path)
    schemes  = Xcodeproj::Project.schemes(pods_project_path)
    unless schemes.include? pod_name
      Xcodeproj::XCScheme.share_scheme(project.path, pod_name)
    end
    "Success share #{pod_name}"
  end
  #
  # remove a target of project
  #Arguments:
  #  project_path:(project_path)
  #  target_to_remove:(target_to_remove)
  # Example4:
  # >>  PodfileTool.removeTarget(args[0], args[1])
  # => puts "#{target.name} did remove from project!!"
  #
  #
  def self.removeTarget(project_path, target_to_remove)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      puts target.name
      if target.name == target_to_remove
          target.remove_from_project
          puts "#{target.name} did remove from project!!"
      end
    end
    project.save
  end
  #
  # remove a target frame_search_path of project
  #Arguments:
  #  project_path:(project_path)
  #  target_to_remove:(target_to_remove)
  #  frame_search_path:(frame_search_path)
  # Example4:
  # >>  PodfileTool.removeTargetFrameSearchPath(args[0], args[1], args[1])
  # => puts search_paths
  #
  #
  def self.removeTargetFrameSearchPath(project_path, target_to_remove, frame_search_path)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      if target.name == target_to_remove
          puts target.name
          target.build_configurations.each { |configuration|
            search_paths = configuration.build_settings['FRAMEWORK_SEARCH_PATHS'] ||= '$(inherited)'
            if search_paths.is_a? Array
              search_paths.delete_if { |e| e == frame_search_path}
            end
            puts search_paths
          }
      end
    end
    project.save
  end

    def self.removePhase(project_path, target_to_remove, p_toremove)
    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
      # puts target.name
      if target.name == target_to_remove
        # puts target.methods
        target.build_phases.each do |aP|
          puts aP.display_name
          if aP.display_name == p_toremove
            aP.remove_from_project
            puts "#{target.name} #{aP} did remove"
          end
          project.save
        end
      end
    end
  end

end