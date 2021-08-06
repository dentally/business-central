# frozen_string_literal: true

require 'test_helper'
require_relative "../lib/business_central/version"

class BusinessCentralTest < Minitest::Test
  def test_version_number_exists
    refute_nil BusinessCentral::VERSION
  end
end
