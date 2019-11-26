require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(line_id: 'abcde12345', access_token: 'abcde12345')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.line_id = '     '
    assert_not @user.valid?
  end

  test 'access_token should be present' do
    @user.access_token = '     '
    assert_not @user.valid?
  end

  test 'line_id addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end
