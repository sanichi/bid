module ProblemHelper
  def problem_vul_menu(selected)
    opts = Problem::VULS.map{ |v| [t("problem.vuls.#{v}"), v] }
    options_for_select(opts, selected)
  end
end
