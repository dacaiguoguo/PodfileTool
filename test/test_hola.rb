require 'minitest/autorun'
require 'PodfileTool'

class HolaTest < Minitest::Test
	def test_podfile
		assert_equal "hello world",
		PodfileTool.outputJson("Podfile")
	end
end
