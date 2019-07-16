=begin
@entity = Risk::Entity::Serasa::CompanySummary(input_data)

@entity.serasa_searches = {
  :quantity
  :last_ocurrence
}

@entity.pefin = {
  :quantity
  :value
  :last_ocurrence
}

@entity.refin = {
  :quantity
  :value
  :last_ocurrence
}

@entity.protest = {
  :quantity
  :value
  :last_ocurrence
}

@entity.lawsuit = {
  :quantity
  :value
  :last_ocurrence
}

@entity.check_ccf = {
  :quantity
  :value
  :last_occurrence
}

=end
module Risk
  module Entity
    module Serasa
      class CompanySummary < Risk::Entity::Base
        attr_accessor :serasa_searches,
                      :pefin,
                      :refin,
                      :protest,
                      :lawsuit,
                      :check_ccf
      end
    end
  end
end
