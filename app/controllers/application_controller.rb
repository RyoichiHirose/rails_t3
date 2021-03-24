class ApplicationController < ActionController::Base

  def hello
    render html: "hello, worlds!"
  end

end
