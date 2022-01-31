class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    authorize_user
  end

  private

  def authorize_user
    email = auth.info[:email] || ""
    user = User.where(email: email).first

    user = create_user(email) unless user.present?
    user.authorizations.create(provider: auth.provider, uid: auth.uid)

    user
  end

  def create_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)

    if email.present?
      user.skip_confirmation!
      user.save!
    else
      user.save!(validate: false)
    end
    user
  end
end
