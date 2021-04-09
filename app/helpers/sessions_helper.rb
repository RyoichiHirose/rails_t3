module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember #remember_token属性をランダム値に→DBのremember_digestをハッシュ値で更新
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #cookieがあれば
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user #session[:user_id]=user.id
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil? #ログイン状態=current_userがいる状態
  end
  
  def forget(user) #Controllerで使用することができる
    user.forget #user.remember_digestをnilで更新
    cookies.delete(:user_id) #cookieを削除
    cookies.delete(:remember_token) #cookieを削除
  end
  
  def log_out
    forget(current_user) #上の処理を実行⑴cookie削除⑵remember_digestをnil
    session.delete(:user_id) #sessionを削除
    @current_user = nil #current_userをnilで更新
  end
  
  def current_user?(user)
    user && user == current_user
  end
  
    # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
