require 'cocoapods'
require 'json'
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
  # => {json}
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
end