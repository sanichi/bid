class Review < ApplicationRecord
  QUALITY = [0, 1, 2, 3, 4, 5]

  belongs_to :user
  belongs_to :problem

  def step(quality)
    self.interval = new_interval(quality)
    if quality >= 3
      self.repetitions += 1
      self.factor = factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
      self.factor = 1.3 if factor < 1.3
    else
      repetitions = 0
    end
    self.attempts += 1
    self.due = Time.now + interval.days
    self
  end

  def new_interval(quality)
    if quality >= 3
      case repetitions
      when 0
        1
      when 1
        6
      else
        (interval * factor).ceil
      end
    else
      1
    end
  end
end
