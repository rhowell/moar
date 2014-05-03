
namespace :moar do
  desc 'Initiates a db:migrate and generates mock AR Models'
  task migrate: [:'db:migrate'] do
    puts 'yay'
  end
end


