require 'rails_helper'

RSpec.describe "Tweets", type: :request do

  before do
    2.times do
      company = Company.create(name: Faker::Company.name)
      2.times do |index|
        user = User.create(display_name: Faker::Name.name, email: Faker::Internet.email, username: "user_#{company.id}_#{index+1}", company_id: company.id)
        10.times do
          Tweet.create(body: Faker::GreekPhilosophers.quote, user_id: user.id)
        end
      end
    end

  end

  describe '#index' do
    let(:result) { JSON.parse(response.body) }
    let(:params) { { page: 1 } }

    it 'return sorted by created_at and paginated tweets' do
      get tweets_path(params)

      expect(result.size).to eq(5)
      expect(result.first['id']).to eq Tweet.order('created_at DESC').first.id
    end
  end
end
