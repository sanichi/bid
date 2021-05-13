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

  def problem_pagination_links(id)
    ids = session[:last_problem_search].to_s.split(",")
    return unless ids.length > 1
    ind = ids.index(id.to_s)
    return nil unless ind
    parts = []
    parts.push "#{ind+1} #{t('pagination.of')} #{ids.length}"
    parts.push link_to(t("pagination.prev"), problem_path(ids[ind-1])) unless ind == 0
    parts.push link_to(t("pagination.next"), problem_path(ids[ind+1])) unless ind + 1 == ids.length
    raw parts.join(t("pagination.sep"))
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
