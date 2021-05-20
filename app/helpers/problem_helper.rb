module ProblemHelper
  PER_PAGE = [5, 10, 20]
  DEF_PAGE = PER_PAGE[1]

  def problems_per_page(per_page)
    PER_PAGE.include?(per_page.to_i) ? per_page.to_i : DEF_PAGE
  end

  def problems_per_page_menu(selected)
    selected = DEF_PAGE unless PER_PAGE.include?(selected.to_i)
    opts = PER_PAGE.map{ |pp| [pp.to_s, pp] }
    options_for_select(opts, selected)
  end

  def problem_vul_menu(selected)
    opts = Problem::VULS.map{ |v| [t("problem.vuls.#{v}"), v] }
    options_for_select(opts, selected)
  end

  def problem_shape_data
    Problem.pluck(:shape).uniq.sort.reverse
  end

  def problem_category_data
    Problem.pluck(:category).uniq.sort
  end

  def problem_order_menu(selected)
    opts = [
      [t("hand.points"),        "points"],
      [t("hand.shape"),          "shape"],
      [t("problem.category"), "category"],
    ]
    options_for_select(opts, selected)
  end

  def problem_vulnerability(vul)
    case vul
    when "vul"
      t("problem.vuls.ns")
    when "non"
      t("problem.vuls.ew")
    else
      t("problem.vuls.#{vul}").downcase
    end
  end

  def problem_pagination_links(id)
    ids = session[:last_problem_list].to_s.split(",")
    return unless ids.length > 0
    ind = ids.index(id.to_s)
    return nil unless ind
    parts = []
    parts.push "#{ind+1} #{t('pagination.of')} #{ids.length}"
    if ind == 0
      parts.push session[:prev_problem_page] if session[:prev_problem_page].present?
    else
      parts.push link_to(t("pagination.prev"), problem_path(ids[ind-1]), id: "prev_link")
    end
    if ind + 1 == ids.length
      parts.push session[:next_problem_page] if session[:next_problem_page].present?
    else
      parts.push link_to(t("pagination.next"), problem_path(ids[ind+1]), id: "next_link")
    end
    raw parts.join(t("pagination.sep"))
  end

  def show_bid(bid)
    case bid
    when /\A(P|X|XX)\Z/
      t("bids.#{$1}")
    when /\A(\d)([CSN])\z/
      $1 + t("bids.#{$2}")
    when /\A(\d)([DH])\z/
      raw('%s<span class="red-suit">%s</span>' % [$1, t("bids.#{$2}")])
    else
      bid
    end
  end
end
