module UserHelper
  def admin(user)
    t("symbol.#{user.admin? ? 'tick' : 'cross'}")
  end
end
