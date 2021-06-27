require_relative 'spec_helper.rb'
require_relative '../models/ticket_generator.rb'
require 'byebug'

describe TicketGenerator do
  context 'Generate Object' do
    it 'should generate nil object' do
     tg = TicketGenerator.new()
     expect(tg).to be_an_instance_of(TicketGenerator)
    end
  end

  context 'validate ticket of size 3x9' do
   it 'should add preper blank if all rows elemnts are zero other than first row' do
    tg = TicketGenerator.new
    tg.ticket = [[9,19,29,39,49,59,69,79,90],[0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0]]
    tg.validate_ticket
    expect(tg.ticket[0].count(0)).to eql(4)
    expect(tg.ticket[1].count(0)).to eql(4)
    expect(tg.ticket[2].count(0)).to eql(4)
   end

   it 'should add preper blank if only last row elemnts are zero' do
    tg = TicketGenerator.new
    tg.ticket = [[1,10,20,30,40,50,60,70,80], [9,19,29,39,49,59,69,79,90], [0,0,0,0,0,0,0,0,0]]
    tg.validate_ticket
    expect(tg.ticket[0].count(0)).to eql(4)
    expect(tg.ticket[1].count(0)).to eql(4)
    expect(tg.ticket[2].count(0)).to eql(4)
   end
  end

  context 'Get column limits' do
    it 'should return 80 as lower limit and 90 as uppper limit for 9th column' do
      tg = TicketGenerator.new
      limits = tg.send(:get_column_limits, 8) #[0,1,2,3,4,5,6,7,8]
      expect(limits[:low]).to eql(80)
      expect(limits[:high]).to eql(90)
    end
  end

  context 'Generate Ticket' do
    it 'shoudld generate new default 3x9 ticket' do
      tg = TicketGenerator.new()
      tg.generate_new_ticket
      expect(tg.ticket.count).to eql(3)
      expect(tg.ticket.first.count).to eql(9)
      expect(tg.ticket[0].count(0)).to eql(4)
      expect(tg.ticket[1].count(0)).to eql(4)
      expect(tg.ticket[2].count(0)).to eql(4)
    end

    it 'shoudld generate new default 4x9 ticket' do
     TicketGenerator::NUMBER_OF_TICKET_ROWS = 4
     tg = TicketGenerator.new()
     tg.generate_new_ticket
     expect(tg.ticket.count).to eql(4)
     expect(tg.ticket.first.count).to eql(9)
     expect(tg.ticket[0].count(0)).to eql(4)
     expect(tg.ticket[1].count(0)).to eql(4)
     expect(tg.ticket[2].count(0)).to eql(4)
     expect(tg.ticket[3].count(0)).to eql(4)
    end

    it 'shoudld generate new default 4x10 ticket' do
     TicketGenerator::NUMBER_OF_TICKET_ROWS = 4
     TicketGenerator::NUMBER_OF_TICKET_COLUMNS = 10
     tg = TicketGenerator.new()
     tg.generate_new_ticket
     expect(tg.ticket.count).to eql(4)
     expect(tg.ticket.first.count).to eql(10)
     expect(tg.ticket[3].count(0)).to eql(4)
    end
  end
end