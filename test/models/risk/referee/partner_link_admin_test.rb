require 'test_helper'

class Risk::Referee::PartnerLinkAdminTest < ActiveSupport::TestCase
  test '.call' do
    evidences = {
      partner_data: [
        {
          cpf: '111111111',
          role: 'not defined'
        },
        {
          cpf: '222222222',
          role: 'admin'
        },
        {
          cpf: '333333333',
          role: 'admin/associate'
        },
        {
          cpf: '444444444',
          role: nil
        },
        {
          cpf: '555555555',
          role: 'associate'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(evidences)

    expected = [
      {
        code: 'partner_link_admin_111111111',
        title: 'Partner Link Admin',
        description: '111111111',
        params: {},
        evidence: {
          partner_role: 'not defined'
        },
        flag: Risk::KeyIndicatorReport::GRAY_FLAG
      },
      {
        code: 'partner_link_admin_333333333',
        title: 'Partner Link Admin',
        description: '333333333',
        params: {},
        evidence: {
          partner_role: 'admin/associate'
        },
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      },
      {
        code: 'partner_link_admin_444444444',
        title: 'Partner Link Admin',
        description: '444444444',
        params: {},
        evidence: {
          partner_role: nil
        },
        flag: Risk::KeyIndicatorReport::GRAY_FLAG
      },
      {
        code: 'partner_link_admin_555555555',
        title: 'Partner Link Admin',
        description: '555555555',
        params: {},
        evidence: {
          partner_role: 'associate'
        },
        flag: Risk::KeyIndicatorReport::YELLOW_FLAG
      },
    ]

    assert_equal expected, Risk::Referee::PartnerLinkAdmin.new(decorated_evidence).call
  end
end
