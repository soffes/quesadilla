require 'test_helper'

module Quesadilla
  class QuesadillaTest < TestCase
    def test_that_it_has_a_version_number
      refute_nil VERSION
    end

    def test_module_method
      assert_equal 'Hi', Quesadilla.extract('Hi')[:display_text]
    end
  end
end
