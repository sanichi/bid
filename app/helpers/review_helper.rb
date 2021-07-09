module ReviewHelper
  PER_PAGE = [5, 10, 20]
  DEF_PAGE = PER_PAGE[0]

  def reviews_per_page(per_page)
    PER_PAGE.include?(per_page.to_i) ? per_page.to_i : DEF_PAGE
  end

  def reviews_per_page_menu(selected)
    selected = DEF_PAGE unless PER_PAGE.include?(selected.to_i)
    opts = PER_PAGE.map{ |pp| [pp.to_s, pp] }
    options_for_select(opts, selected)
  end

  def review_order_menu(selected)
    opts = %w/due new day days week/.map{ |o| [t("review.types.#{o}"), o] }
    options_for_select(opts, selected)
  end

  def review_interval(days)
    if days <= 9
      "#{days}d"
    else
      weeks = (days / 7.0).round
      if weeks <= 9
        "#{weeks}w"
      else
        months = (days / 30.0).round
        if months <= 9
          "#{months}m"
        else
          years = (days / 365.0).round
          "#{years}y"
        end
      end
    end
  end
end
