module Risk
  module Service
    class NewCNPJStrategy < Risk::Service::CNPJAnalysis
      pipeline_list Risk::Pipeline::NewCNPJ::Serasa,
                    Risk::Pipeline::NewCNPJ::BigDataCorp
    end
  end
end
