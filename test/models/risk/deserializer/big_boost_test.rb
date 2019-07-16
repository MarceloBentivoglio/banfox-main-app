module Risk
  module Deserializer
    class BigBoostTest < ActiveSupport::TestCase
      def described_class
        Risk::Deserializer::BigBoost
      end

      def subject
        Risk::Deserializer::BigBoost.new(mocked_response)
      end

      test 'returns a company entity' do
        entity = described_class.call(mocked_response)
        assert_kind_of Risk::Entity::Base, entity
      end

      test '.official_name' do
        expected = 'BANCO DO BRASIL SA'
        assert_equal expected, subject.official_name 
      end

      test '.trade_name' do
        expected = 'DIRECAO GERAL'
        assert_equal expected, subject.trade_name
      end

      test '.tax_status' do
        expected = 'ATIVA'
        assert_equal expected, subject.tax_status
      end

      test '.tax_origin' do
        expected = 'Receita Federal'
        assert_equal expected, subject.tax_origin
      end

      test '.founded_date' do
        expected = Date.new(1966,8,1)
        assert_equal expected, subject.founded_date
      end

      def mocked_response
        {
          "Result": [
            {
              "MatchKeys": "doc{xxxxxxxxxxxxxx}",
              "BasicData": {
                "TaxIdNumber": "xxxxxxxxxxxxxx",
                "TaxIdCountry": "Brazil",
                "AlternativeIdNumbers": {},
                "OfficialName": "BANCO DO BRASIL SA",
                "TradeName": "DIRECAO GERAL",
                "Aliases": {},
                "NameUniquenessScore": -1,
                "FoundedDate": "1966-08-01T00:00:00Z",
                "Age": 52,
                "IsHeadquarter": true,
                "HeadquarterState": "",
                "TaxIdStatus": "ATIVA",
                "TaxIdOrigin": "Receita Federal",
                "TaxRegimes": {
                  "Simples": false
                },
                "Activities": [
                  {
                    "IsMain": true,
                    "Code": "6422100",
                    "Activity": "BANCOS MULTIPLOS, COM CARTEIRA COMERCIAL"
                  },
                  {
                    "IsMain": false,
                    "Code": "6499999",
                    "Activity": "OUTRAS ATIVIDADES DE SERVICOS FINANCEIROS NAO ESPECIFICADAS ANTERIORMENTE"
                  }
                ],
                "LegalNature": {
                  "Code": "2038",
                  "Activity": "SOCIEDADE DE ECONOMIA MISTA"
                },
                "CreationDate": "2014-03-29T00:00:00Z",
                "LastUpdateDate": "2019-02-15T00:00:00Z",
                "AdditionalOutputData": {
                  "Capital": "60000000000.00"
                }
              }
            }
          ],
          "QueryId": "fd733821-71b6-4cc3-be1d-43f57dcd2df8",
          "ElapsedMilliseconds": 82,
          "Status": {
            "basic_data": [
              {
                "Code": 0,
                "Message": "OK"
              }
            ]
          }
        }
      end
    end
  end
end
