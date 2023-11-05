require 'fileutils'
require 'erb'

class Generator
  attr_reader :operating_system, :packages, :parents

  def initialize(operating_system, repo_dir)
    @operating_system = operating_system
    @packages = Parser.new(repo_dir).parse_packages
    @order = 1
  end

  def generate_markdown
    clear_docs
    dist_markdown
  end

  def dist_markdown
    packages.each do |dist, suites|
      increment_order
      @dist = dist
      template = build_template('dist')
      Dir.mkdir("./docs/#{@dist.downcase}")
      File.write("./docs/#{@dist}.md", template)
      suite_markdown(suites)
    end
  end

  def suite_markdown(suites)
    suites.each do |suite, architectures|
      increment_order
      @suite = suite
      template = build_template('suite')
      Dir.mkdir("./docs/#{@dist.downcase}/#{suite.downcase}")
      File.write("./docs/#{@dist}/#{suite}.md", template)
      arch_markdown(architectures)
    end
  end

  def arch_markdown(architectures)
    architectures.each do |arch, packages|
      increment_order
      @arch = arch
      @pkgs = packages
      template = build_template('arch')
      Dir.mkdir("./docs/#{@dist.downcase}/#{@suite.downcase}/#{arch}")
      File.write("./docs/#{@dist}/#{@suite}/#{arch}.md", template)
    end
  end

  def increment_order
    @order += 1
  end

  def build_template(type)
    template = File.read("./templates/#{type}.md.erb")
    ERB.new(template).result(binding)
  end

  def clear_docs
    Dir.glob('./docs/*').each do |file|
      FileUtils.rm_rf(file)
    end
  end
end
