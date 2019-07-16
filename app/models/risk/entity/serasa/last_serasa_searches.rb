module Risk
  module Entity
    module Serasa
      class LastSerasaSearches < Risk::Entity::Base
        attr_accessor :count_per_month, :count_per_month_last_year,
                      :last_searches
                      
      end
    end
  end
end  
