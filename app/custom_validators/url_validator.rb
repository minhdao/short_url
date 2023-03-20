class UrlValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    unless value.present? && valid_url(value)
      record.errors.add(attribute.to_sym, 'invalid format')
    end
  end

  private

  # Take advantage of Ruby URI class implementation to validate URL
  def valid_url(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end