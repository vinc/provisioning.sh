class QueryStringConstraint
  def initialize(key)
    @key = key
  end

  def matches?(req)
    req.params.has_key?(@key)
  end
end

Rails.application.routes.draw do
  get 'welcome/index'

  resources :manifests, param: :uuid, only: %i[show new create destroy]

  # Redirect /?uuid=<uuid> to /manifests/<uuid>.js
  constraints(QueryStringConstraint.new(:uuid)) do
    root to: redirect { |_, req| "/manifests/#{req.params[:uuid]}.sh" }
  end

  root "welcome#index"
end
