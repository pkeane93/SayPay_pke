class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :trips, dependent: :destroy
  has_many :expenses, through: :trips
  has_many :chats, dependent: :destroy

  # TODO: update currency with expense way of handling currencies
  validates :base_currency, inclusion: { in: Expense::VALID_CURRENCIES }, allow_nil: true
  validates :first_name, presence: true
end
