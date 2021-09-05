require 'pry-byebug'
require 'date'



class Stake
  attr_accessor :amount, :avy, :roi, :start_time
  def initialize(amount = 0, avy = 0)
    amount = amount.to_f
    @roi = amount
    @amount = amount
    @avy = avy
    @day = 0
    @start_time = Date.today
    @current_date = @start_time
  end

  def one_day_passes!
    @amount += amount * daily_av.to_f
    # display_status
    @current_date += 1
    @day += 1
    @income = @amount - @roi
    monthly_message if @current_date.day == 1 || new_year?
    print "+$#{(amount * daily_av.to_f).round(3)} "
  end

  def daily_av
    (@avy / 100) / 356.0
  end

  def monthly_message
    puts "*******************************************************"
    puts ">                     #{month}   #{"[#{@current_date.year}]" if new_year?}"

    display_status
  end

  def display_status
    puts "> Actual: $#{amount}         -     Acc Income: +$#{income}"
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
    @amount.round(3)
  end
  def income
    @income.round(3)
  end
end

def init(input)

  core = Stake.new(100, 300)
  puts "Ingreso inicial: $#{core.roi}"
  puts "AVY: #{core.avy}%"
  puts ">                     #{core.month}   #{"[#{core.current_date.year}]" if core.new_year?}"

  if input.zero?
    loop do
      core.one_day_passes!
      sleep(0.2)
    end
  else
    input.times do
      core.one_day_passes!
      sleep(0.2)
    end
  end
end

answer = gets.chomp.to_i
init(answer)
