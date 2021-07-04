module ProblemHelper
  def problem_vul_menu(selected)
    opts = Problem::VULS.map{ |v| [t("problem.vuls.#{v}"), v] }
    options_for_select(opts, selected)
  end

  def problem_shape_data
    Problem.pluck(:shape).uniq.sort.reverse
  end

  def problem_shape_menu(selected)
    opts = Problem.pluck(:shape).uniq.sort.reverse.map{ |o| [o, o] }
    opts.unshift [t("hand.shape"), ""]
    options_for_select(opts, selected)
  end

  def problem_category_data
    Problem.pluck(:category).uniq.sort
  end

  def problem_category_menu(selected)
    opts = Problem.pluck(:category).uniq.sort.map{ |o| [o.truncate(15), o] }
    opts.unshift [t("problem.category"), ""]
    options_for_select(opts, selected)
  end

  def problem_order_menu(selected)
    opts = [
      [t("order"),                    ""],
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

  def show_bid(bid, hide)
    text =
      case bid
      when /\A(P|X|XX)\Z/
        t("bids.#{$1}")
      when /\A(\d)([CSN])\z/
        $1 + t("bids.#{$2}")
      when /\A(\d)([DH])\z/
        '%s<span class="red-suit">%s</span>' % [$1, t("bids.#{$2}")]
      else
        bid
      end
    if hide
      raw('<span id="modesty">%s</span><span id="answer">%s</span>' % [t("symbol.hide"), text])
    else
      raw(text)
    end
  end

  def show_suit(suit)
    sym = t("bids.#{suit}")
    return sym if suit == "C" || suit == "S"
    raw "<span class=\"red-suit\">#{sym}</span>"
  end
end
