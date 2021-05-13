module ProblemHelper
  def problem_vul_menu(selected)
    opts = Problem::VULS.map{ |v| [t("problem.vuls.#{v}"), v] }
    options_for_select(opts, selected)
  end

  def problem_shape_menu(selected)
    opts = Problem.pluck(:shape).uniq.sort.reverse.map{ |o| [o, o] }
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end

  def problem_category_menu(selected)
    opts = Problem.pluck(:category).uniq.sort.map{ |o| [o.truncate(15), o] }
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end

  def problem_order_menu(selected)
    opts = [
      [t("hand.points"),        "points"],
      [t("hand.shape"),          "shape"],
      [t("problem.category"), "category"],
    ]
    options_for_select(opts, selected)
  end

  def show_bid(bid)
    case bid
    when /\A(P|X|XX)\Z/
      t("bids.#{$1}")
    when /\A(\d)([CDHSN])\z/
      $1 + t("bids.#{$2}")
    else
      bid
    end
  end
end
