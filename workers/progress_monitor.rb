# frozen_string_literal: true

module Filter
  # Infrastructure to filter while yielding progress
  module Monitor
    CLONE_PROGRESS = {
      'STARTED' => 10,
      'RETRIEVE' => 30,
      'THIRTY' => 50,
      'SIXTY' => 80,
      'NINETY' => 95,
      'FINISHED' => 100
    }.freeze

    def self.starting_percent
      CLONE_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      CLONE_PROGRESS['FINISHED'].to_s
    end

    def self.percent(stage)
      CLONE_PROGRESS[stage].to_s
    end
  end
end
