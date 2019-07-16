module Risk
  module Entity
    module Serasa
      class AdminGroup < Risk::Entity::Base
        attr_accessor :fullname, :cpf, :nationality, 
                      :role, :sign_in_at, :term_of_office,
                      :contract_entail, :civil_state
      end
    end
  end
end
