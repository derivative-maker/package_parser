# frozen_string_literal: true

require_relative 'test_helper'

class ParserTest < Minitest::Test
  def setup
    @kicksecure_parser = Parser.new('../kicksecure-repository')
  end

  def test_it_has_a_workdir
    assert_equal @kicksecure_parser.workdir, Dir.pwd
  end

  def test_it_adds_dists
    skip
    Dir.chdir(@kicksecure_parser.repo_dir + '/dists')
    dists = Dir.glob('*').select { |file| File.directory? file }
    Dir.chdir(@kicksecure_parser.workdir)
    @kicksecure_parser.add_dists
    suites = {
      main: {},
      non_free: {},
      contrib: {}
    }
    dists.each do |dist|
      assert_equal @kicksecure_parser.distro_packages[dist], suites
    end
  end

  def test_it_adds_architectures
    @kicksecure_parser.add_dists
    @kicksecure_parser.add_packages
  end
end
