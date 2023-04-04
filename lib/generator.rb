class Generator
  attr_reader :operating_system, :parser

  def initialize(operating_system, repo_dir)
    @operating_system = operating_system
    @parser = Parser.new(repo_dir)
  end

  def generate_html
    @parser.packages
  end
end
