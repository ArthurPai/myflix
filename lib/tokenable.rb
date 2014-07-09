module Tokenable
  extend ActiveSupport::Concern

  included do
    class_attribute :token_column
    after_create :generate_token
  end

  def generate_token
    update_column(self.token_column.to_sym, SecureRandom.urlsafe_base64)
  end

  module ClassMethods
    def tokenable_column(col_name)
      self.token_column = col_name
    end
  end
end