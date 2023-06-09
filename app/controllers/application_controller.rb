class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  include Devise::Controllers::Helpers
  before_action :authenticate_user!, unless: -> { request.format.json? }
  # before_action :authenticate_user!
end
