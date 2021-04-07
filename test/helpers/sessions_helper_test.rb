require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user) #remember_tokenの生成、DBにremember_digestの保存、cookieにtoken,idの保存
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in? #!current_user.nil?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user #remember_tokenとdigestが不一致
  end
end