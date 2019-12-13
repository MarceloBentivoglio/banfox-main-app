module Risk
  module Presenter
    class CompanyReport

      attr_reader :key_indicator_report

      def initialize(key_indicator_report)
        if key_indicator_report.evidences['serasa_api'].keys.any?
          @serasa = key_indicator_report.evidences.dig(
            'serasa_api',
            key_indicator_report.evidences['serasa_api'].keys.first
          )
        end

        @big_data_corp = key_indicator_report.evidences.dig('big_data_corp')

        @key_indicator_report = key_indicator_report
      end

      def lawsuits_tj
        return @lawsuits_tj if !@lawsuits_tj.nil?
        begin
        partner_documents = @big_data_corp.dig('companies','Result',0, "OwnersLawsuits",'Lawsuits')&.keys

        partner_data = self&.partners&.select {|partner| partner_documents&.member? CPF.new(partner[:cpf]).stripped }
                                     &.map do |partner|
                                       partner_cpf = CPF.new(partner[:cpf]).stripped
                                       partner[:lawsuits_tj] = @big_data_corp.dig('companies','Result',0, "OwnersLawsuits",'Lawsuits', partner_cpf)
                                       unless partner[:lawsuits_tj].nil?
                                         partner[:lawsuits_tj]['Lawsuits'].each do |lawsuits|
                                           partner_polarity = lawsuits["Parties"]&.select {|party| party["Doc"] == partner_cpf }&.first["Polarity"]
                                           lawsuits[:partner_polarity] = partner_polarity
                                         end
                                       end

                                       partner
                                     end

        @lawsuits_tj = {
          total: partner_data.reduce(0) {|total, partner| total + (partner.dig(:lawsuits_tj,'Lawsuits')&.size || 0)},
          per_partner: partner_data&.map do |partner|
            partner.dig(:lawsuits_tj,'Lawsuits')&.map do |lawsuit|
              {
                name: partner[:name],
                number: lawsuit['Number'],
                court_name: lawsuit['CourtName'],
                main_subject: lawsuit['MainSubject'],
                polarity: lawsuit[:partner_polarity],
                value: ActionController::Base.helpers.number_to_currency(lawsuit['Value'])
              }
            end
          end
        }

        rescue Exception => e
          @lawsuits_tj = []
        end

        @lawsuits_tj
      end

      def lawsuits
        @serasa["lawsuit"].map do |lawsuit|
          date = Date.parse(lawsuit["date"]).strftime("%d-%m-%Y")
          value = ActionController::Base.helpers.number_to_currency(lawsuit['value'])
          {
            date: date,
            value: value,
            operation_nature: lawsuit["operation_nature"],
          }
        end
      end

      def protests
        @serasa["protest"].map do |protest|
          date = Date.parse(protest["date"]).strftime("%d-%m-%Y")
          value = ActionController::Base.helpers.number_to_currency(protest['value'])
          location = "#{protest['city']} - #{protest['state']}"
          {
            location: location,
            date: date,
            value: value,
          }
        end
      end

      def pefins
        @serasa["pefin"].map do |pefin|
          date = Date.parse(pefin["date"]).strftime("%d-%m-%Y")
          value = ActionController::Base.helpers.number_to_currency(pefin['value'])
          {
            date: date,
            value: value,
          }
        end
      end

      def refins
        @serasa["refin"].map do |refin|
          date = Date.parse(refin["date"]).strftime("%d-%m-%Y")
          value = ActionController::Base.helpers.number_to_currency(refin['value'])
          {
            date: date,
            value: value,
          }
        end
      end

      def bankruptcies
        @serasa["bankruptcy"].map do |bank|
          date = Date.parse(bank["date"]).strftime("%d-%m-%Y")
          {
            date: date,
            kind: bank["kind"],
            origin: bank["origin"],
          }
        end
      end

      def created_at
        @key_indicator_report&.created_at&.strftime('%d %B %Y')
      end

      def simples_nacional?
        @big_data_corp&.dig("companies", "Result",0,"BasicData","TaxRegimes", "Simples")
      end

      def company_name
        @serasa&.dig('company_data', 'company_name')&.titleize
      end

      def company_website
        @serasa&.dig('company_data', 'website')
      end

      def cnpj
        @serasa&.dig('company_data', 'cnpj')
      end

      def social_capital
        social_capital = @serasa&.dig('company_data', 'social_capital')
        return 'Não consta' if social_capital.nil?

        "R$ #{social_capital.to_money}"
      end

      def company_founded_in
        founded_in = @serasa&.dig('company_data', 'founded_in')
        return 'Não consta ano de fundação' if founded_in.nil?
        Date.parse(founded_in).strftime('%d %B %Y')
      end

      def company_operating_since
        founded_in = @serasa&.dig('company_data', 'founded_in')
        return 'Não consta ano de fundação' if founded_in.nil?
        company_age = Date.today.year - Date.parse(founded_in).year

        if company_age.zero?
          'Empresa iniciou a operação neste ano'
        else
          "#{company_age} ano(s) de operação"
        end
      end

      def company_address
        @serasa&.dig('company_data', 'address')
      end

      def company_district
        @serasa&.dig('company_data', 'district')
      end

      def company_city
        @serasa&.dig('company_data', 'city')
      end

      def company_state
        @serasa&.dig('company_data', 'state')
      end

      def company_zipcode
        @serasa&.dig('company_data', 'zip_code')
      end

      def company_cnae
        activities = @big_data_corp&.dig("companies", "Result",0,"BasicData","Activities")
        return [] if activities.nil?
        
        activities
      end

      def company_branches
        branches = @serasa&.dig('company_data', 'branches_quantity')&.to_i
        return 'Informação sobre filiais não disponível' if branches.nil?

        if branches.zero?
          'Esta empresa não possui filiais'
        else
          "Esta empresa possui #{branches} filiais"
        end
      end

      def company_employees
        employees = @serasa&.dig('company_data', 'employee_quantity')&.to_i
        return 'Informação sobre filiais não disponível' if employees.nil?

        "Esta empresa possui de #{total_employee_range} funcionários"
      end

      def total_income_range
        @big_data_corp&.dig('companies','Result',0,'EconomicGroups','EconomicGroups',0,'TotalIncomeRange')
      end

      def total_employee_range
        @big_data_corp&.dig('companies','Result',0,'EconomicGroups','EconomicGroups',0,'TotalEmployeesRange')
      end

      def partners
        @serasa&.dig('partner_data').map do |docs|
          finnancial_problems = false
          formatted_cpf = complete_cpf(docs['cpf'])&.formatted
          next if formatted_cpf.nil?
          partner_data = @big_data_corp['partners']
                                       .select do |partner|
                                         big_data_corp_cpf = partner.dig('Result',0,'BasicData','TaxIdNumber')
                                         serasa_cpf = CPF.new(formatted_cpf).stripped

                                         big_data_corp_cpf == serasa_cpf
                                       end.uniq {|partner| partner.dig('Result',0, 'BasicData', 'TaxIdNumber')}

          next {} if partner_data.nil? || partner_data.empty?
          partner_data = partner_data.first['Result']
          birth_date = partner_data.first.dig('BasicData', "BirthDate")
          unless birth_date.nil?
            birth_date = Date.parse(birth_date).strftime('%d/%m/%Y')
          end

          business_relationships = partner_data&.first&.dig("BusinessRelationships", "BusinessRelationships").select {|business| business['RelationshipType'] == 'OWNERSHIP'}

          financial_data = {
            number_of_minimum_wage: partner_data&.first
                                                &.dig('FinantialData','IncomeEstimates','COMPANY OWNERSHIP')
                                                &.titleize
                                                &.gsub('De', 'de')
                                                &.gsub('Sm', 'salários mínimos'),
            total_assets: transform_number_range_to_money_format(partner_data&.first
                                                                             &.dig('FinantialData','TotalAssets'))
          }

          finnancial_problems = true if !docs["lawsuit"].empty? || !docs["protest"].empty? || !docs["refin"].empty? || !docs["pefin"].empty? || !docs["bankruptcy_participation"].empty? || !docs["bad_check"].empty?

          lawsuits = docs["lawsuit"].map do |lawsuit|
            date = Date.parse(lawsuit["date"]).strftime("%d-%m-%Y")
            value = ActionController::Base.helpers.number_to_currency(lawsuit['value'])
            {
              date: date,
              value: value,
              operation_nature: lawsuit["operation_nature"],
            }
          end

          protests = docs['protest'].map do |protest|
            date = Date.parse(protest["date"]).strftime("%d-%m-%Y")
            value = ActionController::Base.helpers.number_to_currency(protest['value'])
            location = "#{protest['city']} - #{protest['state']}"
            {
              location: location,
              date: date,
              value: value,
            }
          end

          pefins = docs["pefin"].map do |pefin|
            date = Date.parse(pefin["date"]).strftime("%d-%m-%Y")
            value = ActionController::Base.helpers.number_to_currency(pefin['value'])
            {
              date: date,
              value: value,
            }
          end

          refins = docs["refin"].map do |refin|
            date = Date.parse(refin["date"]).strftime("%d-%m-%Y")
            value = ActionController::Base.helpers.number_to_currency(refin['value'])
            {
              date: date,
              value: value,
            }
          end

          bankruptcies = docs["bankruptcy_participation"].map do |bank|
            date = Date.parse(bank["lawsuit_date"]).strftime("%d-%m-%Y")

            {
              date: date,
              type: bank["participation_type"],
              company: bank["company"],
              cnpj: banf["cnpj"]
            }
          end

          bad_checks = docs["bad_check"].map do |bad_check|
            date = Date.parse(bad_check["date"]).strftime("%d-%m-%Y")
            value = ActionController::Base.helpers.number_to_currency(bad_check['value'])
            {
              date: date,
              value: value,
              city: bad_check["city"],
              check_number: bad_check["check_number"],
            }
          end

          {
            name:  docs['name']&.strip&.titleize,
            cpf: formatted_cpf,
            age: partner_data.first.dig('BasicData', "Age"),
            role: translate_role(docs['role']),
            birth_date: birth_date,
            address: docs.dig('street_name')&.strip,
            district: docs.dig('district')&.strip,
            city: docs.dig('city')&.strip,
            state: docs.dig('state')&.strip,
            entry_date: partner_entry_date(docs['cpf']),
            business_relationships: business_relationships&.uniq {|n| n['RelatedEntityName']},
            financial_data: financial_data,
            pefins: pefins,
            refins: refins,
            protests: protests,
            lawsuits: lawsuits,
            bankruptcy_participations: bankruptcies,
            bad_checks: bad_checks,
            finnancial_problems: finnancial_problems
          }
        end&.select {|partner| !partner.nil? }
           &.select {|partner| !partner.empty? }
           &.uniq {|partner| partner[:cpf] }
      end

      def company_summary
        serasa_key = key_indicator_report.evidences['serasa_api'].keys.first
        evidences = key_indicator_report.evidences.dig('serasa_api', serasa_key)

        [
          company_summary_lawsuit(evidences['lawsuit']),
          company_summary_protest(evidences['protest']),
          company_summary_pefin(evidences['pefin']),
          company_summary_refin(evidences['refin']),
          company_summary_bankruptcy(evidences['bankruptcy'])
        ]
      end

      def company_summary_bankruptcy(bankruptcy)
        if bankruptcy.any?
          { class: 'alert-text', title: "Possui pedido de falência de ativos"}
        else
          { class: 'info-text', title: 'Não possui pedidos de falência de ativos' }
        end
      end

      def company_summary_lawsuit(lawsuits)
        if lawsuits.any?
          quantity = lawsuits.first['quantity'].to_i
          protest_total_value = lawsuits.reduce(0) {|sum, protest| sum + protest['value'].to_i }
          total_value = ActionController::Base.helpers.number_to_currency(protest_total_value )

          { class: 'alert-text', title: "#{quantity} Ações Judiciais totalizando #{total_value}"}
        else
          { class: 'info-text', title: 'Não possui ações judiciais' }
        end
      end

      def company_summary_pefin(pefins)
        if pefins.any?
          quantity = pefins.first['quantity'].to_i
          total_value = ActionController::Base.helpers.number_to_currency(pefins.first['total_value'])

          { class: 'alert-text', title: "#{quantity} Pefin(s) totalizando #{total_value}"}
        else
          { class: 'info-text', title: 'Não possui Pefins' }
        end
      end

      def company_summary_refin(refins)
        if refins.any?
          quantity = refins.first['quantity'].to_i
          total_value = ActionController::Base.helpers.number_to_currency(refins.first['total_value'])

          { class: 'alert-text', title: "#{quantity} Refin(s) totalizando #{total_value}"}
        else
          { class: 'info-text', title: 'Não possui Refins' }
        end
      end

      def company_summary_protest(protests)
        if protests.any?
          quantity = protests.first['quantity'].to_i
          protest_total_value = protests.reduce(0) {|sum, protest| sum + protest['value'].to_i }
          total_value = ActionController::Base.helpers.number_to_currency(protest_total_value )

          { class: 'alert-text', title: "#{quantity} Protestos totalizando #{total_value}"}
        else
          { class: 'info-text', title: 'Não possui Refins' }
        end
      end

      def partner_entry_date(cpf)
        begin
        documents = @serasa['partner_documents'].select {|partner| partner['cpf_or_cnpj'] == cpf }
        if documents.any?
          entry_date = documents.first['entry_date']
          if !entry_date.nil?
            return Date.parse(entry_date).strftime('%d/%m/%Y')
          end
        end
        rescue Exception => e
          return ''
        end

        nil
      end

      def transform_number_range_to_money_format(expression)
        return "" if expression.nil?
        expression = expression.split
        
        "#{expression_number_to_money_format(expression[2])}"
      end

      def expression_number_to_money_format(expression)
        number = expression.downcase
                  .gsub('k', '000')
                  .gsub('mm', '000000')

        ActionController::Base.helpers.number_to_currency(number)
      end

      def translate_role(role)
        case role
        when 'admin/associate'
          'Sócio Administrador'
        when 'admin'
          'Administrador'
        when 'associate'
          'Sócio'
        when 'not defined'
          'Participação não definida no banco de dados'
        end
      end

      def injuction?
        key_indicator_report&.key_indicators&.dig('injuction', 'flag') ==  Risk::KeyIndicatorReport::YELLOW_FLAG
      end

      def complete_cpf(cpf)
        return nil if cpf.nil?

        cpf = cpf.split('').map {|digit| digit.to_i }
        cpf << CPF::VerifierDigit.generate(cpf)
        cpf << CPF::VerifierDigit.generate(cpf)

        cpf = CPF.new(cpf.map {|digit| digit.to_s }.join)
      end
    end
  end
end
