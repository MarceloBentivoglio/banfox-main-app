module Risk
  module Service
    class RecurrentOperationStrategy < Risk::Service::Operation
      #Interface Enforcement
      pipeline_list Risk::Pipeline::Serasa,
                    Risk::Pipeline::PartnerSerasa,
                    Risk::Pipeline::CrossSerasaIndicators

    end
  end
end
