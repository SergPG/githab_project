# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubService do
  describe '#call' do
    subject(:call) { described_class.new(user_login).call }

    let(:user_login) { 'SergPG' }
    let(:result) do
      {
        name: 'Serhii Popov',
        repos: %w[
          blog car cookbook favorite github_project
          hospital movies myrailsapp mytodo react-fml spending start_up
        ]
      }
    end

    it do
      VCR.use_cassette('github_api') do
        expect(call).to eq(result)
      end
    end

    context 'when user is unknow' do
      let(:user_login) { 'lossjqqq' }
      let(:result) do
        {
          errors: { user_info: 'Not Found', repos: 'Not Found' }
        }
      end

      it do
        VCR.use_cassette('github_unknow_user_api') do
          expect(call).to eq(result)
        end
      end
    end
  end
end
