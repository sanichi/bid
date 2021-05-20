module ApplicationHelper
  def author_menu(selected)
    opts = User.pluck(:name, :id)
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end

  def pagination_links(pager)
    links = Array.new
    links.push(link_to t("pagination.frst"), pager.frst_page, remote: pager.remote, id: "pagn_frst") if pager.after_start?
    links.push(link_to t("pagination.next"), pager.next_page, remote: pager.remote, id: "pagn_next") if pager.before_end?
    links.push(link_to t("pagination.prev"), pager.prev_page, remote: pager.remote, id: "pagn_prev") if pager.after_start?
    links.push(link_to t("pagination.last"), pager.last_page, remote: pager.remote, id: "pagn_last") if pager.before_end?
    raw "#{pager.min_and_max} #{t('pagination.of')} #{pager.count} #{links.size > 0 ? '∙' : ''} #{links.join(t("pagination.sep"))}"
  end

  def center(xs: 0, sm: 0, md: 0, lg: 0, xl: 0, xx: 0)
    klass = []
    klass.push "offset-#{(12 - xs) / 2} col-#{xs}"         if xs > 0
    klass.push "offset-sm-#{(12 - sm) / 2} col-sm-#{sm}"   if sm > 0
    klass.push "offset-md-#{(12 - md) / 2} col-md-#{md}"   if md > 0
    klass.push "offset-lg-#{(12 - lg) / 2} col-lg-#{lg}"   if lg > 0
    klass.push "offset-xl-#{(12 - xl) / 2} col-xl-#{xl}"   if xl > 0
    klass.push "offset-xxl-#{(12 - xx) / 2} col-xxl-#{xx}" if xx > 0
    klass.any? ? klass.join(" ") : "col-12"
  end

  def home_page
    controller_name == "pages" && action_name == "home"
  end

  def col(s)
    case s
    when true
      "col"
    when false, nil
      ""
    else
      s.to_s.gsub(/(\A| )((?:sm|md|lg|xl|xxl)-)?(\d)/){"#{$1}col-#{$2}#{$3}"}
    end
  end
end
