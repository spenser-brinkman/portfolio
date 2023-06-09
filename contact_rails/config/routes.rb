# frozen_string_literal: true

Rails.application.routes.draw do
  post '/contact', to: 'email#create'
  get '*path', to: 'application#raise_not_found'
  match '/', to: 'application#handle_head_request', via: [:head]
end
