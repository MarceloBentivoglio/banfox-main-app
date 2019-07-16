module Risk
  module Entity
    module Serasa
      class CorporateControl < Risk::Entity::Base
        attr_accessor :share_capital, :realized_capital
      end
    end
  end
end
