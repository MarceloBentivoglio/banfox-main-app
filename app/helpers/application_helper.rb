module ApplicationHelper
  def current_controller_name
    controller.controller_name.to_s
  end

  def current_action_name
    controller.action_name.to_s
  end
end
