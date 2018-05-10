class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :password_digest, presence: true

  before_validation :ensure_session_token
  attr_reader :password

  has_many :rental_requests,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :CatRentalRequest

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user == nil
    user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

end
