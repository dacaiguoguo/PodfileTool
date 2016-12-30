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
  def self.outputJson(path)
    podfile_hash = Pod::Podfile.from_file(path).to_hash
    podfile_json = JSON.pretty_generate(podfile_hash)
    puts podfile_json
  end
end