# frozen_string_literal: true

require_relative 'test_helper'

class GeneratorTest < Minitest::Test
  def setup
    @kicksecure_md_generator = Generator.new('kicksecure', './test/data/kicksecure-repository')
  end

  def test_it_has_an_operating_system
    assert_equal @kicksecure_md_generator.operating_system, 'kicksecure'
  end

  def test_it_has_packages
    assert_instance_of Hash, @kicksecure_md_generator.packages
  end

  def test_it_clears_docs
    @kicksecure_md_generator.clear_docs
    assert Dir.glob('./docs/*').empty?
  end

  def test_it_generates_markdown
    data = @kicksecure_md_generator.packages
    @kicksecure_md_generator.clear_docs
    @kicksecure_md_generator.generate_markdown
    dist_key = data.keys.sample
    dist = data[dist_key]
    suite_key = data[dist_key].keys.sample
    suite = data[dist_key][suite_key]
    arch_key = data[dist_key][suite_key].keys.sample
    arch = data[dist_key][suite_key][arch_key]
    pkg = data[dist_key][suite_key][arch_key].sample

    dist_file = File.read("./docs/#{dist_key}-#{suite_key}.md")
    arch_file = File.read("./docs/#{dist_key}-#{suite_key}/#{arch_key}.md")
    pkg_file = File.read("./docs/#{dist_key}-#{suite_key}/#{arch_key}/#{pkg[:package]}.md")
  end
end
