# frozen_string_literal: true

class GithubClient
  MAIN_URL = 'https://api.github.com/users/'

  def initialize(user_login)
    @user_login = user_login
  end

  def personal_info
    client.get(user_login)
  end

  def repos
    client.get("#{user_login}/repos")
  end

  private

  attr_reader :user_login

  def client
    @client ||= Faraday.new(
      url: MAIN_URL,
      request: { timeout: 5 }
    )
  end
end
