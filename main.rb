require_relative 'models/ticket_generator.rb'

tg = TicketGenerator.new()
tg.generate_new_ticket
puts "**********************************"
tg.ticket.each do |row|
 puts row.join('  ')
end
puts "**********************************"