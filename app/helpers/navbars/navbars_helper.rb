module Navbars
  module NavbarsHelper
    def highlight_navbar_item(controller, action, position)
      return "navbar-current-page" if define_position(controller, action) == position
    end

    def check_current_page_subnavbar(path)
      "sub-navbar-current-page" if current_page?(path)
    end

    def check_need_of_subnavbar(controller, action)
      return true if ["installments.store", "installments.opened", "installments.history"].include?("#{controller}.#{action}")
      return false
    end

    def define_position(controller, action)
      return "left" if ["sellers.dashboard"].include?("#{controller}.#{action}")
      return "right" if ["installments.store", "installments.opened", "installments.history"].include?("#{controller}.#{action}")
    end
  end
end
