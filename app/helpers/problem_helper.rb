module ProblemHelper
  def problem_vul_menu(selected)
    opts = Problem::VULS.map{ |v| [t("problem.vuls.#{v}"), v] }
    options_for_select(opts, selected)
  end

  def problem_shape_menu(selected)
    opts = Problem.pluck(:shape).uniq.sort.reverse
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end

  def problem_order_menu(selected)
    opts = %w/points shape/.map{ |o| [t("hand.#{o}"), o] }
    options_for_select(opts, selected)
  end
end
