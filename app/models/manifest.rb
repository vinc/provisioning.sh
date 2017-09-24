class Manifest < ApplicationRecord
  before_save do
    self.uuid ||= SecureRandom.uuid
  end

  def to_param
    uuid
  end
end
