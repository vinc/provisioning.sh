class QueryStringConstraint
  def initialize(key)
    @key = key
  end

  def matches?(req)
    req.params.has_key?(@key)
  end
end

Rails.application.routes.draw do
  resources :manifests, param: :uuid

  # Redirect /?uuid=<uuid> to /manifests/<uuid>.js
  constraints(QueryStringConstraint.new(:uuid)) do
    root to: redirect { |_, req| "/manifests/#{req.params[:uuid]}.sh" }
  end

  root "manifests#new"
end
