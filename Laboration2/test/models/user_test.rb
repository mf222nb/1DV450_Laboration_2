require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Should not save without name" do
    t = User.new
    t.password = "testPass"
    t.key = "testKey"
    assert_not t.save
  end
end
