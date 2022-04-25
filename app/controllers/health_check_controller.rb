class HealthCheckController < ApplicationController
  skip_before_action :authorized

  def ping
    render status: :ok
  end

  def health_check
    ActiveRecord::Base.connection.execute('select 1')
    render status: :ok
  end
end
