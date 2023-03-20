class ShortLinkService

  # str_time is to allow the choice of producing the same output or
  # generating a new output for each original_link and uuid
  def self.hash(original_link, uuid, str_time = nil)
    str_time ||= gen_str_time
    Digest::SHA1.hexdigest(original_link + uuid + str_time)
  end

  def self.build(id)
    "#{protocol}://#{domain}.#{top_level_domain}/#{id}"
  end

  private

  def self.gen_str_time
    DateTime.current.strftime("%H%M%S%L%N")
  end

  def self.protocol
    'http'
  end

  def self.domain
    'short'
  end

  def self.top_level_domain
    'er'
  end
end