# frozen_string_literal: true

class GithubService
  def initialize(user_login)
    @user_login = user_login
  end

  def call
    {
      name: request_user_name,
      repos: request_user_repos
    }
  rescue Faraday::TimeoutError => e
    error_message(e.message)
  end

  private

  attr_reader :user_login

  def request_user_name
    parse_body(github_client.personal_info)['name']
  end

  def request_user_repos
    parse_body(github_client.repos).map do |repo|
      repo['name']
    end
  end

  def parse_body(response)
    data = JSON.parse(response.body)
    return error_message(data['message']) unless response.success?

    data
  end

  def github_client
    @github_client ||= GithubClient.new(user_login)
  end

  def error_message(message)
    "Something went wrong: #{message}"
  end
end
