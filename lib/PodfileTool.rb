require 'cocoapods'
require 'json'
require 'cocoapods-core'

class PodfileTool
  def self.outputJson(path)
    podfile_hash = Pod::Podfile.from_file(path).to_hash
    podfile_json = JSON.pretty_generate(podfile_hash)
    puts podfile_json
  end

  def self.hi
    puts "Hello world!"
  end
end