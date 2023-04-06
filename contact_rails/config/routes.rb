# frozen_string_literal: true

Rails.application.routes.draw do
  post '/', to: 'contact#create'
end
