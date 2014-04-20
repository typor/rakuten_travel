every '10 6,9,12,15,18,21 * * *' do
  runner 'VacantScheduler.perform_async(0, 7)'
end
every '10 7,13,19 * * *' do
  runner 'VacantScheduler.perform_async(8, 7)'
end
every 1.day, :at => '2:00 am' do
  runner 'VacantScheduler.perform_async(15, 30)'
end

every :sunday, :at => '3:00 am' do
  runner 'VacantScheduler.perform_async(45, 60)'
end