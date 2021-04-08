class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness:true
                    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  #引数stringをハッシュ値に変換
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    #remember_token属性をランダム値に
    self.remember_token = User.new_token
    
    #DBのremember_digestカラムをremember_tokenのハッシュ値で更新
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
    # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #user.remember_digestをnilで更新
  def forget
    update_attribute(:remember_digest, nil)
  end

end
