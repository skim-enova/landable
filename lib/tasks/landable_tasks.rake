namespace :landable do
  desc "Populate a landable database with basic themes"
  task :seed => :environment do
    Landable::Theme.where(name: 'Blank').first_or_create!({
      body: '',
      description: 'A completely blank theme; only the page body will be rendered.'
    })

    Landable::Theme.where(name: 'Minimal').first_or_create!({
      body: File.read(File.expand_path('../minimal_theme.liquid', __FILE__)),
      description: 'A minimal HTML5 template'
    })
  end
end
