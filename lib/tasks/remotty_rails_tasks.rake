namespace :remotty_rails do
  desc "Migrate RemottyRails::Participation for support multi room"
  task :migrate_participation do
    RemottyRails::User.find_each do |user|
      participation = RemottyRails::Participation.find_by(id: user.remotty_rails_participation_id)
      participation.update(user: user) if participation
    end
  end
end
