# frozen_string_literal: true

# Submissions Controller
class SubmissionsController < ApplicationController
  before_action :set_workout_post, only: %i[new history create edit update]
  before_action :set_exercise_posts, only: %i[new history]

  before_action :set_workout_submissions, only: %i[history]

  before_action :require_admin, only: %i[history]

  before_action :build_workout_submission, only: %i[create]

  def history; end

  # GET
  def index; end

  # GET
  def show; end

  # GET
  def new
    redirect_to edit_submission_path(params[:workout_post_id]) if WorkoutSubmission.exists?(user_id: current_user.id, workout_post_id: params[:workout_post_id])

    @workout_submission = WorkoutSubmission.new
    # @workout_submission = WorkoutSubmission.find_or_initialize_by(user_id: current_user.id, workout_post_id: params[:workout_post_id])
    # @exercise_submission = ExerciseSubmission.new
  end

  # GET
  def edit
    redirect_to new_submission_path(params[:workout_post_id]) if WorkoutSubmission.where(user_id: current_user.id, workout_post_id: params[:workout_post_id]).empty?
    @workout_submission = WorkoutSubmission.where(user_id: current_user.id, workout_post_id: WorkoutPost.current_wod).first
    # @workout_post = WorkoutPost.current_wod
  end

  # POST
  def create
    update(params) if WorkoutSubmission.exists?(user_id: current_user.id, workout_post_id: params[:workout_post_id])
    exercise_submissions_data = params[:exercise_submission].to_unsafe_h.map do |ep_id, fields|
      { exercise_post_id: ep_id, unit_value: get_uv(fields), user: current_user, opt_out: fields.fetch('opt_out', false) }
    end
    @workout_submission.exercise_submissions.build(exercise_submissions_data)
    respond_to do |format|
      # If the workout submission and all exercise submissions are valid
      if @workout_submission.save
        format.html { redirect_to '/wod', notice: 'Workout was successfully submitted' }
      else
        format.html { redirect_to new_submission_url(params[:workout_post_id]), notice: 'Workout submission was not valid' }
      end
    end
  end

  def update
    create(params) if WorkoutSubmission.where(user_id: current_user.id, workout_post_id: params[:workout_post_id]).empty?
    @workout_submission = @workout_post.workout_submissions.where(user: current_user).first

    exercise_submissions_data = params[:exercise_submission].to_unsafe_h.transform_values { |fields| { unit_value: get_uv(fields), opt_out: fields.fetch('opt_out', false) } }

    respond_to do |format|
      # If the workout submission and all exercise submissions are valid
      if exercise_submissions_data.all? { |_k, v| v[:unit_value] }
        ExerciseSubmission.update(exercise_submissions_data.keys, exercise_submissions_data.values)
        format.html { redirect_to '/wod', notice: 'Submission was successfully edited' }
      else
        format.html { redirect_to edit_submission_url(params[:workout_post_id]), notice: 'Workout submission was not valid' }
      end
    end
  end

  # DELETE
  def destroy; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout_post
    @workout_post = WorkoutPost.find(params[:workout_post_id])
  end

  def set_exercise_posts
    @exercise_posts = @workout_post.exercise_posts
  end

  def set_workout_submissions
    @workout_submissions = @workout_post.workout_submissions
  end

  def build_workout_submission
    @workout_submission = @workout_post.workout_submissions.build({ user: current_user, submitted_datetime: DateTime.now })
  end

  # Check if a string represents a valid number
  def numeric?(field)
    !Float(field).nil?
  rescue StandardError
    false
  end

  # Get the unit value from the params, either as a single value or a combination of minutes and seconds
  def get_uv(fields)
    if numeric?(fields[:unit_value])
      fields[:unit_value]
    elsif numeric?(fields[:minutes]) && numeric?(fields[:seconds])
      (fields[:minutes].to_f * 60) + fields[:seconds].to_f
    end
  end
end
