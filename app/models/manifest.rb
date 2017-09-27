class Manifest < ApplicationRecord
  # TODO: store those in postgres instead of exporting everything into `content`
  FIELDS = [:ssh, :app, :platform, :hosting, :dns, :cloud, :providers].freeze

  attr_accessor(*FIELDS)

  before_save do
    self.uuid ||= SecureRandom.uuid

    # transform csv into ruby array
    if app.is_a?(Hash) && app[:domains].is_a?(String)
      app[:domains] = app[:domains].split(/[, ]+/)
    end

    fill_blank_attributes

    # export attributes to database (in JSON format)
    FIELDS.each do |field|
      value = send(field)
      content[field] = value unless value.nil?
    end
  end

  def fill_blank_attributes
    self.providers ||= {}

    if cloud.present? # landing page
      self.hosting = {
        provider: cloud[:provider],
        server: {}
      }
      self.dns = {
        provider: cloud[:provider]
      }
      
      case cloud[:provider]
      when "digitalocean"
        hosting[:server][:region] = "sfo1"
        hosting[:server][:image] = "ubuntu-16-04-x64"
        case platform[:provider]
        when "dokku"
          hosting[:server][:size] = "1gb"
        when "flynn"
          hosting[:server][:size] = "4gb"
        end
      when "aws"
        hosting[:region] = "us-west-2"
        hosting[:server][:image_id] = "ami-6e1a0117"
        case platform[:provider]
        when "dokku"
          hosting[:server][:flavor_id] = "t2.micro"
        when "flynn"
          hosting[:server][:flavor_id] = "t2.medium"
        end
      end

      case platform[:provider]
      when "dokku"
        platform[:version] = "v0.10.4"
      end

      self.cloud = nil
    end
    
    providers[hosting[:provider]] = {}
    providers[dns[:provider]] = {}
    dns[:domain] ||= app[:domains].first || "example.com" # error if empty?
    app[:name] ||= dns[:domain].tr(".", "-")
  end

  def to_param
    uuid
  end
end
