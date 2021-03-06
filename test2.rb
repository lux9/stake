require 'pry-byebug'
require 'date'



class Stake
  attr_accessor :amount, :avy, :roi, :start_time
  def initialize(attr = {amount: 0, avy: 0})
    amount = attr[:amount].to_f
    @roi = attr[:amount]
    @amount = attr[:amount]
    @avy = attr[:avy]
    @day = 1
    @start_time = Date.today
    @current_date = @start_time
  end

  def one_day_passes!
    @amount += amount * daily_av.to_f # if @day % 5 == 1
    # display_status
    @current_date += 1
    @day += 1
    @income = @amount - @roi
    print "+$#{(amount * daily_av.to_f).round(2)} "
    monthly_message if @current_date.day == 1 || new_year?

  end

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
    puts ">                                          ***Actual: $#{amount}         -     Acc Income: +$#{income}***"
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

  def amount
    @amount.round(2)
  end
  def income
    @income.round(2)
  end
end

def init(input)
  core = Stake.new(
    amount: 120,
    avy: 420
  )
  puts "Ingreso inicial: $#{core.roi}"
  puts "AVY: #{core.avy}%"
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
