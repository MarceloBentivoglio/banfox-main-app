module Trackable
  extend ActiveSupport::Concern

  def status
    statuses.each do |method_name, written_status|
      return [method_name, written_status] if self.__send__("#{method_name}?")
    end
  end
end
