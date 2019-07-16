module Risk
  module Entity
    module Serasa
      class Company < Risk::Entity::Base
        attr_accessor :cnpj, :tax_status, :tax_id_status,
                      :company_name, :company_nick_name,
                      :score
                        
                    
      end
    end
  end
end
