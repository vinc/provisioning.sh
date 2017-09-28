class Manifest < ApplicationRecord
  # TODO: store those in postgres instead of exporting everything into `content`
  FIELDS = [:app, :platform, :compute, :dns, :cloud].freeze

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
    if cloud.present? # landing page
      self.compute = {
        provider: cloud[:provider]
      }
      self.dns = {
        provider: cloud[:provider]
      }
      
      case cloud[:provider]
      when "digitalocean"
        compute[:region] = "sfo1"
        compute[:image] = "ubuntu-16-04-x64"
        case platform[:provider]
        when "dokku"
          compute[:size] = "1gb"
        when "flynn"
          compute[:size] = "4gb"
        end
      when "aws"
        compute[:region] = "us-west-2"
        compute[:image_id] = "ami-6e1a0117"
        case platform[:provider]
        when "dokku"
          compute[:flavor_id] = "t2.micro"
        when "flynn"
          compute[:flavor_id] = "t2.medium"
        end
      end

      self.cloud = nil
    end

    case platform[:provider]
    when "dokku"
      platform[:version] = "v0.10.4"
    end
    
    platform[:domain] ||= app[:domains].first || "example.com" # error if empty?
    app[:name] ||= platform[:domain].tr(".", "-")
  end

  def providers
    {}.tap do |hash|
      %w[platform compute dns].each do |field|
        provider = content[field]["provider"]
        hash[provider] = true
      end
    end
  end

  def to_param
    uuid
  end
end
