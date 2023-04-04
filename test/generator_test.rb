# frozen_string_literal: true

require_relative 'test_helper'

class GeneratorTest < Minitest::Test
  def setup
    @kicksecure_html_generator = Generator.new('kicksecure', '../kicksecure-repository')
  end

  def test_it_has_an_operating_system
    assert_equal @kicksecure_html_generator.operating_system, 'kicksecure'
  end

  def test_it_has_a_repo_dir
    assert_instance_of Parser, @kicksecure_html_generator.parser
  end

  def test_it_generates_html
    assert_equal @kicksecure_html_generator.generate_html, "some html"
  end
end
