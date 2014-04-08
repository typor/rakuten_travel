class RakutenTravel::AdminConstraint

  def matches?(request)
    return false unless request.session[:user_id]
    User.exists?(request.session[:user_id])
  end
end