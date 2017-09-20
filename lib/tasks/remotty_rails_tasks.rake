namespace :remotty_rails do
  desc "Migrate RemottyRails::Participation for support multi room"
  task :migrate_multi_room do
    RemottyRails::User.find_each do |user|
      RemottyRails::Participation.find_by(id: user.remotty_rails_participation_id)&.update(user: user)
    end
  end
end
