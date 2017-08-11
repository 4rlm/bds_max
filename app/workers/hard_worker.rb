class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts "His name is #{name} and he has #{count}."
  end

end

HardWorker.perform_async('bob', 5)
