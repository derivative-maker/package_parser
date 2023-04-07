class Parser
  attr_reader :repo_dir, :workdir, :distro_packages

  def initialize(repo_dir)
    @repo_dir = repo_dir
    @workdir = Dir.pwd
    @distro_packages = {}
  end


  def parse_packages
    add_dists
    add_packages
    distro_packages
  end

  def add_dists
    Dir.chdir("#{repo_dir}/dists")
    dists = Dir.glob('*').select {|file| File.directory? file}
    Dir.chdir(workdir)
    dists.each do |dist|
      @distro_packages[dist] = {
        "main": {},
        "non-free": {},
        "contrib": {}
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
      packages = raw_packages.split("Package: ").map do |pkg_data|
        parse_package(pkg_data)
      end.compact
      @distro_packages[dist][suite][arch] = packages
    end
    Dir.chdir(workdir)
  end

  def parse_package(pkg_data)
    return nil if pkg_data.empty?

    {
      package: package(pkg_data),
      version: single_field(pkg_data, "Version"),
      architecture: single_field(pkg_data, "Architecture"),
      maintainer: single_field(pkg_data, "Maintainer"),
      installed_size: single_field(pkg_data, "Installed-Size"),
      recommends: single_field(pkg_data, "Recommends"),
      conficts: single_field(pkg_data, "Conflicts"),
      replaces: single_field(pkg_data, "Replaces"),
      provides: single_field(pkg_data, "Provides"),
      homepage: single_field(pkg_data, "Homepage"),
      priority: single_field(pkg_data, "Priority"),
      section: single_field(pkg_data, "Section"),
      filename: single_field(pkg_data, "Filename"),
      size: single_field(pkg_data, "Size"),
      sha256: single_field(pkg_data, "SHA256"),
      sha1: single_field(pkg_data, "SHA1"),
      md5sum: single_field(pkg_data, "MD5sum"),
      description: description(pkg_data)
    }
  end

  def package(raw)
    raw.match(/.*\n/).to_s.chomp
  end

  def single_field(raw, field)
    raw.match(/#{field}: .*\n/).to_s.chomp.gsub("#{field}: ", "")
  end

  def description(pkg_data)
    pkg_data.split("Description: ").last
  end
end
