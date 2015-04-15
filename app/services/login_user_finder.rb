class LoginUserFinder

  def initialize(user_id)
    @user_id = user_id
  end

  def find
    if in_development? && mock_enabled?
      @current_user = mock_user
    else
      @current_user = User.find_by_id(@user_id)
    end
  end

  private

  def mock_user
    @found ||= User.find_by_id(-1)
    return @found if @found
    u = User.new
    u.id = -1
    u.username = 'developer'
    u.provider = 'twitter'
    u.avatar_url = 'https://abs.twimg.com/sticky/default_profile_images/default_profile_0_reasonably_small.png'
    u.staff = mock_is_staff?
    u.save
    u
  end

  def in_development?
    Rails.env.development?
  end

  def mock_enabled?
    ENV.key?("MOCK_USER")
  end

  def mock_is_staff?
    ENV['MOCK_USER'] == 'staff'
  end

end
