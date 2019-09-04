module Risk
  module Service
    class RecurrentOperationStrategy < Risk::Service::CNPJAnalysis
      #Interface Enforcement
      pipeline_list Risk::Pipeline::RecurrentOperation::Serasa,
                    Risk::Pipeline::RecurrentOperation::PartnerSerasa,
                    Risk::Pipeline::RecurrentOperation::CrossSerasaIndicators

    end
  end
end
