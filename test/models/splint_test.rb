require 'test_helper'

class SplintTest < ActiveSupport::TestCase
  def setup
    @splint = Splint.new(sp_number: 1, content: 'HelloWorld', kpt: 'Keep', line_id: 'abcde12345')
  end

  test 'should be valid' do
    assert @splint.valid?
  end

  test 'line_id should be present' do
    @splint.line_id = '     '
    assert_not @splint.valid?
  end

  test 'sp_number should be present' do
    @splint.sp_number = '     '
    assert_not @splint.valid?
  end

  test 'content should be present' do
    @splint.content = '     '
    assert_not @splint.valid?
  end

  test 'kpt should be present' do
    @splint.kpt = '     '
    assert_not @splint.valid?
  end

  test 'content should not be too long' do
    @splint.content = 'a' * 61
    assert_not @splint.valid?
  end
end
