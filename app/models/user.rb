class User < ApplicationRecord
  # micropostをユーザーはたくさん持っている状態を記述
  # micropost_id が外部キーとして自動的に設定される
  has_many :microposts, dependent: :destroy

  # フォローしているユーザーの状態を記述
  # (UserテーブルとRelationshipテーブルの関連付け)
  # follower_id（フォローしているユーザーのID）が外部キーとなる
  # Userが削除されると関連するカラムが削除される
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  # フォローユーザー対フォロワーユーザーの管理
  # (followedとUserの関連付けをactive_relationshipを通じて行う）
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships,  class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
  # Railsはsource(キー）をfollowersの単数形であるfollowerと自動推測するが、
  # 今回は明示的にsourceを指定する
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name,
            presence: true,
            length: { maximum: 50 } 

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  MIN_PASSWORD_LENGTH = 6
  validates :password,
            presence: true,
            length: { minimum: MIN_PASSWORD_LENGTH },
            allow_nil: true

  has_secure_password

  # 渡されたトークンがダイジェストと一致しているかを確認
  # 戻り値： true -> 一致
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest");
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil);
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "select followed_id from relationships where follower_id = :user_id"
    Micropost.where("user_id in (#{following_ids}) or user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end



  class << self

    def login_auth(params)
      user = User.find_by(email: params[:email].downcase)
      if user && user.authenticate(params[:password])
        if !user.activated?
          message = "Account not activated."
          message += "Check your email for the activation link."
          raise UserActivateError, message
        end
      else
        raise InvalidLoginParameterError, "Invalid email/password combination"
      end

      return user
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password::create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token;
    self.activation_digest = User.digest(activation_token);
  end

end

class UserActivateError < StandardError; end
class InvalidLoginParameterError < StandardError; end
