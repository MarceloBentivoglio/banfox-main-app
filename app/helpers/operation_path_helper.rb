module OperationPathHelper

  def status_bottom_form(status)
    simple_form_for :operation, url: status_bottom_operation_path(status) do |f|  
      yield f 
    end
  end

  def status_bottom_operation_path(status)
    if status == :no_on_going_operation
      operations_path
    elsif status == :completely_approved || status == :partially_approved
      create_document_operations_path
    end
  end
end
