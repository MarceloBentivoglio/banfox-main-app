# == Schema Information
#
# Table name: external_data
#
#  id         :bigint           not null, primary key
#  source     :string
#  raw_data   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  query      :jsonb
#  ttl        :datetime
#

FactoryBot.define do
  factory :external_datum, class: 'Risk::ExternalDatum' do
    source { "test_source" }
    query { { cnpj: "00310523911323" } }
    ttl { DateTime.now + 1.hour }
    raw_data { "" }

    trait :expired_ttl do
      ttl { DateTime.now - 1.hour }
    end

    trait :serasa do
      raw_data { File.open("#{Rails.root}/test/support/files/serasa_example_1.txt").read }
    end

    trait :serasa_diadema do
      raw_data { File.open("#{Rails.root}/test/support/files/20190719_DIADEMA.txt").read }
    end

    trait :serasa_ambev do
      raw_data { File.open("#{Rails.root}/test/support/files/20190722_AMBEV.txt").read }
    end

    trait :serasa_carrefour do
      raw_data { File.open("#{Rails.root}/test/support/files/20190722_CARREFOUR.txt").read }
    end

    trait :serasa_hutchinson do
      raw_data { File.open("#{Rails.root}/test/support/files/20190722_HUTCHINSON.txt").read }
    end

    trait :serasa_marka do
      raw_data { File.open("#{Rails.root}/test/support/files/20190722_MARKA_ARTEFATOS.txt").read }
    end
  end
end
