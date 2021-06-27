* Used Language : Ruby

* Version : 2.6.3

* Run application: ruby HousieHousie/main.rb

* Unit test case running: bundle exec rspec spec

* Other: 
-> main.rb has TicketGenerator object to create new Housie Housie ticket.
-> The logic behind this is: 
1. Generating array of ticket size, here it is 3x9. Each column are generated first and then these columns are added to rows of array.
2. Validating each row for required blanks and numbers.
3. If row is not having required blanks then updating row with required blanks.
4. If row is not having required random numbers then updating row for required random numbers.