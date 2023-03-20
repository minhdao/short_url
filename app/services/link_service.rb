class LinkService

  include ActiveModel::Model

  UNIQ_STR_SIZE = 6.freeze
  UNIQ_STR_NOT_FOUND_ERROR_MESSAGE = 'cannot encode link at the moment'.freeze

  attr_accessor :url, :link
  attr_reader :results

  validates :url, presence: true
  validate :link_created_successfully?

  def initialize(params = {})
    super(params)
  end

  def shorten
    return false if invalid?

    @results = { url: link.url, shorter_url: link.shorter_url }
    true
  end

  private

  def link_id
    @_link_id ||= SecureRandom.uuid
  end

  # Sliding window over the hash to choose a unique substring
  def find_uniq_sub_str(hash, starting, ending)
    while (ending < hash.size)
      return hash[starting..ending] unless Link.find_by(url: hash[starting..ending])

      starting += 1
      ending += 1
    end

    # Can also send an error report to some error server such as Sentry
    errors.add(:base, UNIQ_STR_NOT_FOUND_ERROR_MESSAGE)
  end

  def hash
    @_hash ||= ShortLinkService.hash(url, link_id)
  end

  def uniq_sub_str
    find_uniq_sub_str(hash, 0, UNIQ_STR_SIZE)
  end

  def shorter_url
    return nil if uniq_sub_str.nil?

    @_shorter_url ||= ShortLinkService.build(uniq_sub_str)
  end

  def link
    @_link ||= Link.new(link_id: link_id, url: url, shorter_url: shorter_url)
  end

  def link_created_successfully?
    return if errors.present?

    errors.add(:base, link.errors.full_messages.join(', ')) unless link.save
  end
end