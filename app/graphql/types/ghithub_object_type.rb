# frozen_string_literal: true

module Types
  class GhithubObjectType < Types::BaseObject
    field :name, String
    field :repos, [String]

    def name
      object[:name]
    end

    def repos
      object[:repos]
    end
  end
end
