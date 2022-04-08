require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times do
        create(:user, company: company_1)
      end
      5.times do
        create(:user, company: company_2)
      end
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }
    let!(:company) { create(:company) }
    let!(:user) { create(:user, username: 'Kilmer Luiz', company_id: company.id) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get company_users_path(company_1)

        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |element| element['id'] } ).to eq(company_1.users.ids)
      end
    end

    context 'when fetching users by username' do
      it 'should find user by last name' do
        get company_users_path({ company_id: company.id, username: 'Luiz' })
        expect(result.size).to eq(1)
      end

      it 'should find user by part of the name' do
        get company_users_path({ company_id: company.id, username: 'Lu' })
        expect(result.size).to eq(1)
      end

      it 'should find user by part of the name in upper case' do
        get company_users_path({ company_id: company.id, username: 'LU' })
        expect(result.size).to eq(1)
      end

      it 'should find user by part of the name in lower case' do
        get company_users_path({ company_id: company.id, username: 'lu' })
        expect(result.size).to eq(1)
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do

      end
    end
  end
end
