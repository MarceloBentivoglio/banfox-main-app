module Risk
  module Pipeline
    class Serasa < Risk::Pipeline::Base
      fetch_from Risk::Fetcher::Serasa
    end
  end
end
