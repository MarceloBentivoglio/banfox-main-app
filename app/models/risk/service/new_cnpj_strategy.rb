module Risk
  module Service
    class NewCNPJStrategy < Risk::Service::CNPJAnalysis
      pipeline_list Risk::Pipeline::NewCNPJ::Serasa
    end
  end
end
