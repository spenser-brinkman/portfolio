# frozen_string_literal: true

class ApplicationController < ActionController::API
  def raise_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def handle_head_request
    head :ok
  end
end
