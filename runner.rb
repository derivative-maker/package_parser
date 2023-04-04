require './lib/package_parser'

operating_system = ARGV[1]
repo_dir = ARGV[2]

generator = Generator.new(operating_system, repo_dir)
parser = Parser.new
package_parser.generate_html
