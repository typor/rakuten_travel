set :output, {error: Whenever.path + '/log/whenever_error.log',  standard: Whenever.path + '/log/whenever.log'}

every '10 8,12,16,20 * * *' do
  rake "api:import_charges CHECKCIN=0 COUNT=14"
end

every 1.day, :at => '2:00 am' do
  rake "api:import_charges CHECKCIN=14 COUNT=14"
end

every :saturday, at: '23:00' do
  rake "api:import_charges CHECKCIN=27 COUNT=56"
end

every 1.day, at: '22:00' do
  rake "api:import_hotels"
end