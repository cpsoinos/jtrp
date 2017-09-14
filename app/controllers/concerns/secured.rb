module Secured
  extend ActiveSupport::Concern

  # SCOPES = {
  #   '/items' => ['read:items'],
  #   # '/another_resource'    => ['some:scope', 'some:other_scope']
  # }

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    auth_token
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    JsonWebToken.verify(http_token)
  end
end
