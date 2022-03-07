class HelloController < ApplicationController
  def hello
    render json: { message: 'hello' }
  end
end
