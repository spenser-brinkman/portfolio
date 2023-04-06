# frozen_string_literal: true

Rails.application.routes.draw do
  post '/', to: 'email#create'
end
