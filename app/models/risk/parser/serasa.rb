module Risk
  module Parser
    class Serasa
      attr_accessor :pefin, :refin, :partner_data, :partner_documents
      include CNPJFormatter

      def initialize
        bootstrap_attributes
      end

      def bootstrap_attributes
        @company_data = {
          injuction: false,
          non_profit: false,
        }
        @partner_data = []
        @partner_documents = []
        @pefin = []
        @refin = []
        @protest = []
        @lawsuit = []
        @bankruptcy_participation = []
        @bankruptcy = []
        @debt_overdue = []
        @bad_check = []
        @bad_check_ccf = []
        @lost_check = []
        @serasa_queries = []
        @negative_information = []

        @parsing_partner_data = false
      end

      def call(external_datum)
        return if external_datum.nil?

        serialized = {}

        @raw_data = external_datum.raw_data
        @raw_data.each do |data|
          tags = data.split('#L').map do |line|
            [line[0...6], line[6..(line.length)]]
          end

          tags.each {|tag, value| classify(tag, value) }

          serialized_data = serialize
          serialized[cnpj_root_format(@company_data[:cnpj])] = serialized_data
          bootstrap_attributes
        end

        serialized
      end

      def classify(tag, value)
        case tag
        when '010000'
          parse_company_status(value)
        when '010999'
          parse_non_profit(value)
        when '040101'
          parse_pefin(value)
        when '040102'
          parse_refin(value)
        when '040202'
          parse_negative_information_totals(value)
        when '040301'
          parse_protest(value)
        when '040401'
          parse_lawsuit(value)
        when '010108'
          parse_social_control(value)
        when '010109'
          parse_partner_data(value)
        when '010117'
          parse_partner_pf_data(value)
        when '010119'
          parse_partner_pj_data(value)
        when '040501'
          parse_bankruptcy_participation(value)
        when '040601'
          parse_bankruptcy(value)
        when '040701'
          parse_debt_overdue(value)
        when '040801'
          parse_bad_check(value)
        when '040901'
          parse_bad_check_ccf(value)
        when '041001'
          parse_lost_check(value)
        when '010101'
          parse_company_register_data(value)
        when '010102'
          parse_company_data(value)
        when '010103'
          parse_company_address_1(value)
        when '010104'
          parse_company_address_2(value)
        when '010105'
          parse_company_registration_data(value)
        when '030102'
          parse_serasa_queries(value)
        when '040198'
          parse_injuction(value)
        when '040298'
          parse_injuction(value)
        end
      end

      def serialize
        {
          partner_data: @partner_data,
          partner_documents: @partner_documents,
          company_data: @company_data,
          pefin: @pefin,
          refin: @refin,
          protest: @protest,
          lawsuit: @lawsuit,
          debt_overdue: @debt_overdue,
          bankruptcy_participation: @bankruptcy_participation,
          bankruptcy: @bankruptcy,
          bad_check: @bad_check,
          bad_check_ccf: @bad_check_ccf,
          lost_check: @lost_check,
          serasa_queries: @serasa_queries,
          negative_information: @negative_information
        }
      end

      def parse_serasa_queries(value)
        serasa_query = {
          date: value[0..7],
          name: value[8..42],
          quantity: value[43..46],
          cnpj: value[47..55]
        }

        @serasa_queries << serasa_query
      end

      def parse_company_status(value)
        @company_data[:company_status] = case value[0..1]
                                         when '02'
                                           'ATIVA'
                                         when '03'
                                           'INATIVA'
                                         when '00'
                                           'INAPTA'
                                         when '04'
                                           'NÃO LOCALIZADA'
                                         when '05'
                                           'EM LIQUIDAÇÃO'
                                         when '07'
                                           'NÃO CADASTRADA'
                                         when '06'
                                           'SUSPENSO'
                                         when '09'
                                           'CANCELADO'
                                         else
                                           nil
                                         end
      end

      def parse_non_profit(value)
        @company_data[:non_profit] = true
      end

      def parse_social_control(value)
        @company_data[:social_capital] = value[8..20]
        @company_data[:social_capital_realized] = value[21..33]
      end

      def parse_injuction(value)
        @company_data[:injuction] = true
      end

      def parse_company_registration_data(data)
        @company_data[:founded_in] = data[0..7]
        @company_data[:line_of_business] = data[16..68]
        @company_data[:line_of_business_serasa_code] = data[70..76]
        @company_data[:cnae] = data[97..103]
        @company_data[:cnpj_registration_date] = data[8..15]
        @company_data[:employee_quantity] = data[77..81]
        @company_data[:branches_quantity] = data[88..91]
        @company_data[:branches_quantity_alternative] = data[91..96]
        @company_data[:purchase_percentage] = data[82..84]
        @company_data[:sale_percentage] = data[85..87]
      end

      def parse_company_address_1(data)
        @company_data[:district] = data[70..99]
        @company_data[:address] = data[100..179]
      end

      def parse_company_address_2(data)
        @company_data[:city] = data[0..29]
        @company_data[:state] = data[30..31]
        @company_data[:zip_code] = data[32..40]
        @company_data[:ddd_phone] = data[41..44]
        @company_data[:phone] = data[45..52]
        @company_data[:website] = data[66..135]
      end

      def parse_company_data(data)
        @company_data[:company_name] = data[0..69]
        @company_data[:company_nickname] = data[79..138]
        @company_data[:company_type] = data[150..209]
        @company_data[:nire] = data[139..149]
        @company_data[:tax_option] = data[210..239]
      end

      def parse_company_register_data(data)
        @company_data[:cnpj] = data[84..101]
        @company_data[:register_number] = data[111..121]
        @company_data[:register_number_last_updated_at] = data[122..129]
        @company_data[:last_updated_at] = data[102..109]
      end

      def parse_partner_data(data)
        @partner_documents << {
          entry_date: data[97..104],
          name: data[16..80],
          pf_or_pj: data[0],
          cpf_or_cnpj: data[1..9]
        }
      end

      def parse_partner_pj_data(data)
        @parsing_partner_data = true
        @current_partner_data = {
          cnpj: data[0..8],
          cnpj_detail: data[9..12],
          cnpj_digit: data[13..14],
          incorporation_year: data[15..22],
          information_last_updated_at: data[23..30],
          company_name: data[31..100],
          company_nickname: data[101..130],
          role: parse_role(data[131]),
          consistency_code: data[132],
          refin: [],
          pefin: [],
          protest: [],
          lawsuit: [],
          bankruptcy_participation: [],
          bankruptcy: [],
          debt_overdue: [],
          bad_check: [],
          bad_check_ccf: [],
          lost_check: [],
          negative_information: []
        }

        @partner_data << @current_partner_data
      end

      def parse_partner_pf_data(data)
        @parsing_partner_data = true
        @current_partner_data = {
          cpf: data[0..8],
          document_branch: data[9..12],
          document_digit: data[13..14],
          updated_at: data[15..22],
          name: data[23..82],
          rg: data[83..93],
          born_at: data[94..101],
          role: parse_role(data[102]),
          city_birth: data[103..132],
          state_birth: data[133..134],
          phone_ddd: data[135..138],
          phone: data[139..147],
          branch_line: data[148..151],
          street_name: data[152..221],
          city: data[222..241],
          district: data[242..271],
          state: data[272..273],
          zipcode: data[274..282],
          residence_time: data[283..286],
          situation_status: data[287],
          refin: [],
          pefin: [],
          protest: [],
          lawsuit: [],
          bankruptcy_participation: [],
          bankruptcy: [],
          debt_overdue: [],
          bad_check: [],
          bad_check_ccf: [],
          lost_check: [],
          negative_information: []
        }

        @partner_data << @current_partner_data
      end

      def parse_pefin(data)
        parsed_data = {
          value: data[39...52],
          total_value: data[227..239],
          date: data[18..25],
          quantity: data[1..8]
        }

        if @parsing_partner_data
          @current_partner_data[:pefin] << parsed_data
        else
          @pefin << parsed_data
        end
      end

      def parse_refin(data)
        parsed_data ={
          value: data[39...52],
          total_value: data[227..239],
          date: data[18..25],
          quantity: data[1..8]
        }

        if @parsing_partner_data
          @current_partner_data[:refin] << parsed_data
        else
          @refin << parsed_data
        end
      end

      def parse_negative_information_totals(data)
        negative_information_totals = {
          quantity: data[0..8],
          description: data[9..35],
          initial_month_shortname: data[36..38],
          initial_month_occurrence: data[39..40],
          initial_year_occurrence: data[41..42],
          final_month_shortname: data[43..45],
          final_month_occurrence: data[46..47],
          final_year_occurrence: data[48..49],
          currency: data[50..52],
          value: data[53..65],
          origin: data[66..85],
          agency: data[86..89],
          total_value: data[90..102],
          type: data[103..105]
        }

        append_negative_information_to_respective_owner(negative_information_totals)
      end

      def parse_protest(data)
        protest = {
          quantity: data[0..8],
          date: data[9..16],
          currency: data[17..19],
          value: data[21..32],
          registry: data[33..34],
          city: data[35..64],
          state: data[65..66]
        }

        if @parsing_partner_data
          @current_partner_data[:protest] << protest
        else
          @protest << protest
        end
      end

      def parse_lawsuit(data)
        lawsuit = {
          quantity: data[0..8],
          date: data[9..16],
          operation_nature: data[17..36],
          guarantor: data[37],
          currency: data[38..40],
          value: data[41..53],
        }

        if @parsing_partner_data
          @current_partner_data[:lawsuit] << lawsuit
        else
          @lawsuit << lawsuit
        end
      end

      def parse_bankruptcy_participation(data)
        bankruptcy_participation = {
          quantity: data[0..8],
          lawsuit_date: data[9..16],
          participation_type: data[17..36],
          cnpj: data[37..45],
          company: data[46..113],
        }

        if @parsing_partner_data
          @current_partner_data[:bankruptcy_participation] << bankruptcy_participation
        else
          @bankruptcy_participation << bankruptcy_participation
        end
      end

      def parse_bankruptcy(data)
        bankruptcy = {
          quantity: data[0..8],
          date: data[9..16],
          kind: data[17..36],
          origin: data[37..41],
        }

        if @parsing_partner_data
          @current_partner_data[:bankruptcy] << bankruptcy
        else
          @bankruptcy << bankruptcy
        end
      end

      def parse_debt_overdue(data)
        debt_overdue = {
          quantity: data[0..8],
          date: data[9..16],
          modality: data[17..31],
          currency: data[32..34],
          value: data[35..47],
          title: data[48..62],
          local: data[63..77],
        }

        if @parsing_partner_data
          @current_partner_data[:debt_overdue] = debt_overdue
        else
          @debt_overdue << debt_overdue
        end
      end

      def parse_bad_check(data)
        bad_check = {
          quantity: data[0..8],
          date: data[9..16],
          check_number: data[17..22],
          subheading: data[23..24],
          bank_quantity: data[25..29],
          currency: data[30..32],
          value: data[33..45],
          bank: data[46..57],
          agency: data[58..61],
          city: data[62..91],
          code: data[92..96],
        }

        if @parsing_partner_data
          @current_partner_data[:bad_check] << bad_check
        else
          @bad_check << bad_check
        end
      end

      def parse_bad_check_ccf(data)
        bad_check_ccf = {
          quantity: data[0..8],
          date: data[9..16],
          check_number: data[17..22],
          bank_quantity: data[23..27],
          bank: data[28..43],
          agency: data[44..47],
          city: data[48..77],
          state: data[78..79],
          code: data[80..82]
        }

        if @parsing_partner_data
          @current_partner_data[:bad_check_ccf] << bad_check_ccf
        else
          @bad_check_ccf << bad_check_ccf
        end
      end

      def parse_lost_check(data)
        lost_check = {
          date: data[0..7],
          bank: data[8..23],
          agency: data[24..27],
          account_number: data[28..33],
          account_digit: data[34],
          check_begin: data[35..40],
          check_finish: data[41..46],
          reason: data[47..56],
          account_12: [57..68]
        }

        if @parsing_partner_data
          @current_partner_data[:lost_check] << lost_check
        else
          @lost_check << lost_check
        end
      end

      def append_negative_information_to_respective_owner(negative_information)
        if @parsing_partner_data
          @current_partner_data[:negative_information] << negative_information
        else
          @negative_information << negative_information
        end
      end

      def parse_role(role_id)
        case role_id
        when 'A'
          'admin'
        when 'S'
          'associate'
        when 'D'
          'admin/associate'
        else
          'not defined'
        end
      end

      def parse_situation_status(situation_id)
        case situation_id
        when 'I'
          'inconsistent'
        when 'C'
          'consistent'
        end
      end
    end
  end
end
