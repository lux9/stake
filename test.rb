require 'pry-byebug'
require 'date'



class Stake
  attr_accessor :amount, :avy, :roi, :start_time, :restake
  def initialize(attr = {amount: 0, avy: 0, restake: 0, stop: 0})
    amount = attr[:amount].to_f
    @roi = attr[:amount]
    @amount = attr[:amount]
    @avy = attr[:avy]
    @day = 0
    @start_time = Date.today
    @current_date = @start_time
    @restake = attr[:restake]

    @non_restake = Stake.new({amount: self.amount, avy: self.avy, stop: 1}) unless attr[:stop]

  end

  def one_day_passes!
    if @non_restake
      @non_restake.amount += amount * daily_av.to_f
      @non_restake.current_date += 1
      @non_restake.day += 1
      @non_restake.income = @non_restake.amount - @non_restake.roi
    end
    if @restake.zero?

      @amount += @amount - @roi
    else
      @amount += @amount * daily_av.to_f if @day % @restake == 1

    end
    # display_status
    @current_date += 1
    @day += 1
    @income = @amount - @roi
    print "+$#{(amount * daily_av.to_f).round(2)} "
    monthly_message if @current_date.day == 1 || new_year?
  end

  # private

  def daily_av
    (@avy / 100) / 356.0
  end

  def monthly_message
    jump
    display_status
    jump

    puts "                *******************************************************"
    puts ">                     #{month}   #{"[#{@current_date.year - 2000}]"}" # if new_year?}"
    print "     "
  end

  def display_status
    jump
    puts ">                staked ***Actual: $#{amount.round(2)}         -     Acc Income: +$#{income.round(2)}***"
    puts ">                      non staked ***Actual: $#{@non_restake.amount.round(2)}         -     Acc Income: +$#{@non_restake.income.round(2)}***" if @non_restake
    jump
  end


  def jump
    puts ""
    sleep(0.1)
  end


  def month
    Date::MONTHNAMES[@current_date.month].upcase
  end

  def new_year?
    current_date = (@start_time + @day)
    # puts current_date.month
    current_date.month == 1 && current_date.day == 1
  end


  attr_accessor :current_date, :date, :amount, :day, :income

end

def init(input)
  core = Stake.new(
    amount: 120,
    avy: 420,
    restake: 1
  )
  puts "Ingreso inicial: $#{core.roi}"
  puts "AVY: #{core.avy}%"
  puts "Restake every: #{core.restake} days"

  puts ">                     #{core.month}   #{"[#{core.current_date.year}]" if core.new_year?}"

  if input.zero?
    loop do
      core.one_day_passes!
      sleep(0.1)
    end
  else
    input.times do
      core.one_day_passes!
      sleep(0.1)
    end
  end
end

answer = 0 # gets.chomp.to_i
init(answer)
