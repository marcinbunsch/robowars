module ApplicationHelper

  def user_can_modify_question?(question)
    user_is_staff? || current_user.id == question.user_id
  end

  def user_is_staff?
    current_user.staff?
  end

end
