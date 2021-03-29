class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &. authenticate(params[:session][:password])
   #=if user && user.authenticate
   #「&&」の場合、userがいて初めて右に進めるので、NoMethodErrorになることはない
   #「&.」の場合、nil or trueになる
      log_in user #session[:user_id]=user.id
      redirect_to user #users/:id=>"users#show"
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
  
end
