class User < ApplicationRecord
    after_initialize :init
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

    enum role: [:basic, :intermediate, :advanced, :admin]

    def init
        self.role ||= :basic if self.has_attribute? :role
    end
end
