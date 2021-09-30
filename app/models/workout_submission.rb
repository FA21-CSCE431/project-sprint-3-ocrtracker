class WorkoutSubmission < ApplicationRecord
    belongs_to :workout_post
    belongs_to :user
    has_many :exercise_submissions
    has_many :fistbumps
    has_one :leaderboard_spot
end