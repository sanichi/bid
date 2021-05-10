module NoteHelper
  def author_menu(selected)
    opts = User.pluck(:name, :id)
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end
end
