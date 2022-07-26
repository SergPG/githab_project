# frozen_string_literal: true

class GithubService
  def initialize(user_login)
    @user_login = user_login
    @errors = {}
  end

  def call
    user_data
    repos_data
    return { errors: } if errors.present?

    {
      name: user_data['name'],
      repos: repos_data.map { |repo| repo['name'] }
    }
  rescue Faraday::TimeoutError => e
    { errors: { message: e.message } }
  end

  private

  attr_reader :user_login, :errors

  def user_data
    @user_data ||= request_user_info
  end

  def repos_data
    @repos_data ||= request_user_repos
  end

  def request_user_info
    response = github_client.personal_info
    body = parse_body(response)
    return body if response.success?

    errors.merge!(user_info: body['message'])
  end

  def request_user_repos
    response = github_client.repos
    body = parse_body(response)
    return body if response.success?

    errors.merge!(repos: body['message'])
  end

  def parse_body(response)
    JSON.parse(response.body)
  end

  def github_client
    @github_client ||= GithubClient.new(user_login)
  end
end
