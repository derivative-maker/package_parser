class Parser
  attr_reader :repo_dir, :workdir, :distro_packages

  def initialize(repo_dir)
    @repo_dir = repo_dir
    @workdir = Dir.pwd
    @distro_packages = {}
  end

  def add_dists
    Dir.chdir("#{repo_dir}/dists")
    dists = Dir.glob('*').select {|file| File.directory? file}
    Dir.chdir(workdir)
    dists.each do |dist|
      @distro_packages[dist] = {
        main: {},
        non_free: {},
        contrib: {}
      }
    end
  end

  def add_packages
    @distro_packages.each_key do |dist|
      @distro_packages[dist].each_key do |suite|
        parse_architectures(dist, suite)
      end
    end
  end

  def parse_architectures(dist, suite)
    Dir.chdir("#{repo_dir}/dists/#{dist}/#{suite}")

    architectures = Dir.glob('*').select do |file|
      File.directory?(file) && file != "source"
    end

    architectures.each do |arch|
      raw_packages = File.read("./#{arch}/Packages")
      packages = raw_packages.split("Package: ").map do |package_data|
        parse_package(package_data)
      end.compact
      @distro_packages[dist][suite][arch] = packages
    end
  end

  def parse_package(package_data)
    return nil if package_data.empty?
    binding.pry

    { 
      package: package(package_data),
      version: single_field(package_data, "Version"),
      architecture: single_field(package_data, "Architecture"),
      maintainer: single_field(package_data, "Maintainer"),
      installed_size: single_field(package_data, "Installed-Size"),
      recommends: single_field(package_data, "Recommends"),
      conficts: single_field(package_data, "Conflicts"),
      replaces: single_field(package_data, "Replaces"),
      provides: single_field(package_data, "Provides"),
      homepage: single_field(package_data, "Homepage"),
      priority: single_field(package_data, "Priority"),
      section: single_field(package_data, "Section"),
      filename: single_field(package_data, "Filename"),
      size: single_field(package_data, "Size"),
      sha256: single_field(package_data, "SHA256"),
      sha1: single_field(package_data, "SHA1"),
      md5sum: single_field(package_data, "MD5sum"),
      description: description(package_data)
    }
    binding.pry 
  end

  def package(raw)
    raw.match(/.*\n/).to_s.chomp
  end

  def single_field(raw, field)
    raw.match(/#{field}: .*\n/).to_s.chomp.gsub("#{field}: ", "")
  end

  def description
    binding.pry 
  end
end
