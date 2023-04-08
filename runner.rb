require './lib/generator.rb'
require './lib/parser.rb'

os = ARGV[0]
repo_dir = ARGV[1]

generator = Generator.new(os, repo_dir)
generator.generate_markdown
