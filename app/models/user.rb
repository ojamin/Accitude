class User < ActiveRecord::Base

  attr_accessible :password, :email

  has_and_belongs_to_many :organisations

  after_create :enc_pwd
  before_save :b_enc_pwd
  after_save :a_enc_pwd

  @pwd_mod = false

  ADMIN_USERS = ['admin']

  def is_admin
    return true if ADMIN_USERS.include? self.username
    return false
  end

  def self.user_login(u, p)
    return User.find_by_username u, :conditions => ["password = ?", Digest::SHA512.hexdigest(p)]
  end

  # after create encrypt the plaintext pwd
  def enc_pwd
    connection.execute("update users set password = '#{Digest::SHA512.hexdigest(self.password)}' where username = '#{self.username}' and password = '#{self.password}';")
  end

  # check if pwd was changed on save
  def b_enc_pwd
    if (u = User.find_by_username(self.username))
      unless u.password == self.password
        @pwd_mod = true
      end
    end
  end

  # if pwd was changed on save encrypt it
  def a_enc_pwd
    if @pwd_mod
      @pwd_mod = false
      self.enc_pwd
    end
  end

end
