class Manifest < ApplicationRecord
  FIELDS = [:domain, :ssh, :app, :providers, :dokku, :digitalocean].freeze

  attr_accessor(*FIELDS)

  before_save do
    self.uuid ||= SecureRandom.uuid

    app[:domains] = app[:domains].split(/[, ]+/) if app[:domains].is_a?(String)
    FIELDS.each { |field| content[field] = send(field) }
  end

  def to_param
    uuid
  end
end
