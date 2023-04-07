# frozen_string_literal: true

require_relative 'test_helper'

class ParserTest < Minitest::Test
  def setup
    @kicksecure_parser = Parser.new('../kicksecure-repository')

    Dir.chdir(@kicksecure_parser.repo_dir + '/dists')
    @dists = Dir.glob('*').select { |file| File.directory? file }
    Dir.chdir(@kicksecure_parser.workdir)

    @suites = {
      "main": {},
      "non-free": {},
      "contrib": {}
    }
  end

  def test_it_has_a_workdir
    assert_equal @kicksecure_parser.workdir, Dir.pwd
  end

  def test_it_adds_dists
    @kicksecure_parser.add_dists
    @dists.each do |dist|
      assert_equal @kicksecure_parser.distro_packages[dist], @suites
    end
  end

  def test_it_parses_packages
    @kicksecure_parser.add_dists
    @kicksecure_parser.add_packages
    sample_dist = @dists.sample
    sample_suite = @suites.keys.sample
    sample_arch = @kicksecure_parser.distro_packages[sample_dist][sample_suite].keys.sample
    sample_package = @kicksecure_parser.distro_packages[sample_dist][sample_suite][sample_arch].sample

    assert_instance_of String, sample_package[:package]
    assert_instance_of String, sample_package[:version]
    assert_instance_of String, sample_package[:architecture]
    assert_instance_of String, sample_package[:maintainer]
    assert_instance_of String, sample_package[:installed_size]
    assert_instance_of String, sample_package[:recommends]
    assert_instance_of String, sample_package[:conficts]
    assert_instance_of String, sample_package[:replaces]
    assert_instance_of String, sample_package[:provides]
    assert_instance_of String, sample_package[:homepage]
    assert_instance_of String, sample_package[:priority]
    assert_instance_of String, sample_package[:section]
    assert_instance_of String, sample_package[:filename]
    assert_instance_of String, sample_package[:size]
    assert_instance_of String, sample_package[:sha256]
    assert_instance_of String, sample_package[:sha1]
    assert_instance_of String, sample_package[:md5sum]
    assert_instance_of String, sample_package[:description]
  end
end
