# == Schema Information
#
# Table name: evidences
#
#  id             :bigint           not null, primary key
#  input_data     :jsonb
#  collected_data :jsonb
#  referee_name   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :evidence, class: Risk::Evidence do
    input_data { { cnpj: '96.006.288/0001-80' } }
    collected_data do
      {
        serasa_searches: {
          quantity: 100,
          last_occurrence: Date.new(2019, 6, 1)
        }
      }
    end
    referee_name { "Serasa::Searches" }
  end
end
