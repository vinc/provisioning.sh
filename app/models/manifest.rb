class Manifest < ApplicationRecord
  FIELDS = [:ssh, :app, :platform, :hosting, :dns, :providers].freeze

  attr_accessor(*FIELDS)

  before_save do
    self.uuid ||= SecureRandom.uuid

    if app.is_a?(Hash) && app[:domains].is_a?(String)
      app[:domains] = app[:domains].split(/[, ]+/)
    end

    FIELDS.each { |field| content[field] = send(field) }
  end

  def to_param
    uuid
  end
end
