FactoryBot.define do
  factory :link, class: 'Link' do
    link_id { SecureRandom.uuid }
    url { "http://testlink.com/this/that/here/there/#{SecureRandom.uuid}" }
    shorter_url { "#{SecureRandom.uuid}" }
    click_count { 0 }
    
    trait :invalid do
      link_id { nil }
      url { nil }
      shorter_url { nil }
      click_count { nil }
    end
  end
end
